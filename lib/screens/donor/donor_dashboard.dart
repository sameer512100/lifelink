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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("LifeLink - Donor Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching requests: ${snapshot.error}'));
                  }

                  final donationRequests = snapshot.data ?? [];

                  return donationRequests.isEmpty
                      ? const Center(child: Text("No donation requests found."))
                      : ListView.separated(
                          itemCount: donationRequests.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final request = donationRequests[index];
                            return _buildRequestCard(request);
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

  Widget _buildHeaderCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      color: Colors.white,
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
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
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              label == "Points" ? Icons.star : Icons.favorite,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(DonationRequest request) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.white,
      child: ListTile(
        title: Text(
          "${request.hospitalName} - ${request.bloodType}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            "${request.location}\nContact: ${request.contact}",
            style: const TextStyle(height: 1.4),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(request.timestamp),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _showActionDialog(request),
      ),
    );
  }

  void _showActionDialog(DonationRequest request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Donation Request"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogRow("Hospital", request.hospitalName),
              _buildDialogRow("Blood Type", request.bloodType),
              _buildDialogRow("Location", request.location),
              _buildDialogRow("Contact", request.contact),
              _buildDialogRow("Date", _formatTimestamp(request.timestamp)),
            ],
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.check, color: Colors.green),
              label: const Text("Accept"),
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
            ),
            TextButton.icon(
              icon: const Icon(Icons.close, color: Colors.red),
              label: const Text("Reject"),
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
