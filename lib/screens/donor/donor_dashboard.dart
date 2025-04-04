import 'package:flutter/material.dart';

class DonorDashboard extends StatelessWidget {
  const DonorDashboard({super.key});

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.red[100],
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/user.png'), // Temporary
                ),
                title: const Text("Welcome back, Donor!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

            const SizedBox(height: 30),

            // Donate Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // TODO: Navigate to donation request screen
                },
                icon: const Icon(Icons.favorite),
                label: const Text("Find Requests"),
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
