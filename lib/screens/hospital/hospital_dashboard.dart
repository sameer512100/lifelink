import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/donation_request.dart';

class HospitalDashboard extends StatefulWidget {
  const HospitalDashboard({super.key});

  @override
  State<HospitalDashboard> createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends State<HospitalDashboard> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final String hospitalName = "City Hospital"; // static name for MVP

  List<DonationRequest> myRequests = [];

  @override
  void initState() {
    super.initState();
    _loadMyRequests();
  }

  Future<void> _loadMyRequests() async {
    List<DonationRequest> allRequests = await _firebaseService.fetchDonationRequests();
    setState(() {
      myRequests = allRequests.where((r) => r.hospitalName == hospitalName).toList();
    });
  }

  Future<void> _createDonationRequest() async {
    if (_bloodTypeController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _contactController.text.isEmpty) {
      return;
    }

    final newRequest = DonationRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hospitalName: hospitalName,
      bloodType: _bloodTypeController.text,
      location: _locationController.text,
      contact: _contactController.text,
      timestamp: DateTime.now().toIso8601String(),
    );

    await _firebaseService.addDonationRequest(newRequest);
    _bloodTypeController.clear();
    _locationController.clear();
    _contactController.clear();
    _loadMyRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospital Dashboard"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.deepPurple[100],
              child: ListTile(
                leading: const Icon(Icons.local_hospital, size: 40, color: Colors.deepPurple),
                title: Text(hospitalName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Welcome, let's save lives!"),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Create Donation Request", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _bloodTypeController, decoration: const InputDecoration(labelText: 'Blood Type')),
            TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location')),
            TextField(controller: _contactController, decoration: const InputDecoration(labelText: 'Contact')),
            ElevatedButton(
              onPressed: _createDonationRequest,
              child: const Text("Submit Request"),
            ),
            const SizedBox(height: 20),
            const Text("Your Active Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: myRequests.isEmpty
                  ? const Center(child: Text("No requests yet."))
                  : ListView.builder(
                      itemCount: myRequests.length,
                      itemBuilder: (context, index) {
                        final req = myRequests[index];
                        return Card(
                          child: ListTile(
                            title: Text("${req.bloodType} - ${req.location}"),
                            subtitle: Text("Contact: ${req.contact}"),
                            trailing: Text(req.timestamp.split("T")[0]),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}