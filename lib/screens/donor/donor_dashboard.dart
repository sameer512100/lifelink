import 'package:flutter/material.dart';

class DonorDashboard extends StatelessWidget {
  const DonorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeLink - Donor Home'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, Donor!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.red[100],
              child: ListTile(
                title: const Text('Total Points'),
                subtitle: const Text('1200'),
                trailing: const Icon(Icons.star, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.bloodtype),
                  label: const Text("Request Blood"),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility),
                  label: const Text("View Requests"),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.leaderboard),
                  label: const Text("Leaderboard"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
