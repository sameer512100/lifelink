import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import '../../models/donation_request.dart';

class DonorDashboard extends StatefulWidget {
  const DonorDashboard({super.key});

  @override
  DonorDashboardState createState() => DonorDashboardState();
}

class DonorDashboardState extends State<DonorDashboard> {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic>? _donorInfo;
  bool _loadingInfo = true;

  @override
  void initState() {
    super.initState();
    _loadDonorInfo();
  }

  Future<void> _loadDonorInfo() async {
    try {
      final info = await _firebaseService.getCurrentDonorInfo();
      setState(() {
        _donorInfo = info ?? {};
        _loadingInfo = false;
      });
    } catch (e) {
      setState(() {
        _donorInfo = {};
        _loadingInfo = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load donor info: $e')),
      );
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'No date available';
    if (timestamp is Timestamp) {
      return timestamp.toDate().toString().split(" ")[0];
    } else if (timestamp is DateTime) {
      return timestamp.toString().split(" ")[0];
    } else if (timestamp is String) {
      try {
        return DateTime.parse(timestamp).toString().split(" ")[0];
      } catch (_) {
        return 'Invalid date';
      }
    }
    return 'Unknown date format';
  }

  @override
  void dispose() {
    super.dispose();
    // Add cleanup logic here if additional resources are introduced
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LifeLink - Donor Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.red[100],
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
                title: Text(
                  _loadingInfo
                      ? "Loading..."
                      : "Welcome, ${_donorInfo?['name']?.toString() ?? 'Donor'}!",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Blood Type: ${_donorInfo?['bloodType']?.toString() ?? 'Unknown'}",
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("Points", _donorInfo?['points']?.toString() ?? '0', Colors.green),
                _buildStatCard("Donations", _donorInfo?['donations']?.toString() ?? '0', Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<DonationRequest>>(
                stream: _firebaseService.fetchDonationRequests(),
                builder: (context, snapshot) {
                  print("Connection state: ${snapshot.connectionState}");
                  print("Has data: ${snapshot.hasData}");
                  print("Data: ${snapshot.data}");
                  print("Error: ${snapshot.error}");

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("Waiting for data...");
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print("Error occurred: ${snapshot.error}");
                    return Center(child: Text('Error fetching requests: ${snapshot.error}'));
                  }
                  final donationRequests = snapshot.data ?? [];
                  print("Requests count: ${donationRequests.length}");
                  if (donationRequests.isNotEmpty) {
                    print("First request: ${donationRequests[0]}");
                  }

                  return donationRequests.isEmpty
                      ? const Center(child: Text("No donation requests found."))
                      : ListView.separated(
                          itemCount: donationRequests.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final request = donationRequests[index];
                            return Card(
                              child: ListTile(
                                title: Text("${request.hospitalName} - ${request.bloodType}"),
                                subtitle: Text("${request.location}\nContact: ${request.contact}"),
                                trailing: Text(_formatTimestamp(request.timestamp)),
                                onTap: () => _showActionDialog(request),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showActionDialog(DonationRequest request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Request from ${request.hospitalName}"),
          content: Text(
            "Blood Type: ${request.bloodType}\n"
            "Location: ${request.location}\n"
            "Contact: ${request.contact}\n"
            "Timestamp: ${_formatTimestamp(request.timestamp)}",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _firebaseService.acceptDonationRequest(request.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Request accepted")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text("Accept"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _firebaseService.rejectDonationRequest(request.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Request rejected")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text("Reject"),
            ),
          ],
        );
      },
    );
  }
}