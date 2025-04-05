import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    // Get current user location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Fetch all donors
    QuerySnapshot donorSnapshot = await FirebaseFirestore.instance.collection('donors').get();

    Set<Marker> markers = donorSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final lat = data['location']?['lat'];
      final lng = data['location']?['lng'];
      final name = data['name'];

      if (lat != null && lng != null) {
        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: name),
        );
      } else {
        return null;
      }
    }).whereType<Marker>().toSet();

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requests Location')),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 12,
              ),
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
