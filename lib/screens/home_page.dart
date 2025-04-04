import 'package:flutter/material.dart';
import 'package:lifelink/screens/donor/donor_dashboard.dart';
import 'package:lifelink/screens/hospital/hospital_dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LifeLink - Home"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DonorDashboard()));
              },
              icon: const Icon(Icons.favorite),
              label: const Text("Donor Dashboard"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HospitalDashboard()));
              },
              icon: const Icon(Icons.local_hospital),
              label: const Text("Hospital Dashboard"),
            ),
          ],
        ),
      ),
    );
  }
}
