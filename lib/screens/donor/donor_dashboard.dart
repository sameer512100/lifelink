import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/donation_request.dart';

class DonorDashboard extends StatefulWidget {
  const DonorDashboard({super.key});

  @override
  DonorDashboardState createState() => DonorDashboardState();
}

class DonorDashboardState extends State<DonorDashboard> {
  final FirebaseService _firebaseService = FirebaseService();
  List<DonationRequest> donationRequests = [];

  @override
  void initState() {
    super.initState();
    _loadDonationRequests();
  }

  Future<void> _loadDonationRequests() async {
    List<DonationRequest> requests = await _firebaseService.fetchDonationRequests();
    setState(() {
      donationRequests = requests;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LifeLink"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.red[100],
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
                title: const Text("Welcome back, Donor!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: const Text("You're doing great ❤️"),
              ),
            ),

            const SizedBox(height: 20),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("Points", "1200", Colors.green),
                _buildStatCard("Donations", "5", Colors.orange),
              ],
            ),

            const SizedBox(height: 20),

            // Donation Requests List
            Expanded(
              child: donationRequests.isEmpty
                  ? const Center(child: Text("No donation requests found."))
                  : ListView.builder(
                      itemCount: donationRequests.length,
                      itemBuilder: (context, index) {
                        final request = donationRequests[index];
                        return Card(
                          child: ListTile(
                            title: Text("${request.hospitalName} - ${request.bloodType}"),
                            subtitle: Text(request.location),
                            trailing: Text(request.timestamp),
                          ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 140,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
