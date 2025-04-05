import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart' as services;
import '../../models/donation_request.dart' as model;
import 'package:geolocator/geolocator.dart';

class HospitalDashboard extends StatefulWidget {
  final String hospitalName;

  const HospitalDashboard({super.key, required this.hospitalName});

  @override
  State<HospitalDashboard> createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends State<HospitalDashboard> {
  final services.FirebaseService _firebaseService = services.FirebaseService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String get hospitalName => widget.hospitalName;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospital Dashboard"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHospitalCard(),
            const SizedBox(height: 20),
            const Text(
              "Create Donation Request",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildRequestForm(),
            const SizedBox(height: 30),
            const Text(
              "Your Active Requests",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildRequestsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.deepPurple[100],
      child: ListTile(
        leading: const Icon(Icons.local_hospital, size: 40, color: Colors.deepPurple),
        title: Text(hospitalName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Welcome, let's save lives!"),
      ),
    );
  }

  Widget _buildRequestForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _bloodTypeController,
            decoration: const InputDecoration(
              labelText: 'Blood Type',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.bloodtype),
            ),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Please enter blood type' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Please enter location' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _contactController,
            decoration: const InputDecoration(
              labelText: 'Contact Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Please enter contact number' : null,
          ),
          const SizedBox(height: 15),
          _isSubmitting
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text("Submit Request"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _createDonationRequest,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    return SizedBox(
      height: 300,
      child: StreamBuilder<List<model.DonationRequest>>(
        stream: _firebaseService.getHospitalDonationRequests(hospitalName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return const Center(child: Text("No active requests."));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.bloodtype, color: Colors.red),
                  title: Text("${req.bloodType} - ${req.location}"),
                  subtitle: Text("Contact: ${req.contact}"),
                  trailing: Text(req.timestamp.toDate().toString().split(" ")[0]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _createDonationRequest() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isSubmitting = true);

  try {
    // 1. Ask permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    // 2. Get current location
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 3. Create request with location and required parameters
    final newRequest = model.DonationRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hospitalName: hospitalName,
      bloodType: _bloodTypeController.text.trim(),
      location: _locationController.text.trim(),
      contact: _contactController.text.trim(),
      timestamp: Timestamp.now(),
      hospitalId: 'hospital_unique_id', // Use actual hospital ID here
      createdAt: Timestamp.now(), // Timestamp for when the request is created
      latitude: position.latitude,
      longitude: position.longitude,
    );

    await _firebaseService.addDonationRequest(newRequest);

    // Clear form fields
    _bloodTypeController.clear();
    _locationController.clear();
    _contactController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Request submitted successfully!")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    setState(() => _isSubmitting = false);
  }
}



}
