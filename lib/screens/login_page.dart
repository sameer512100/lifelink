import 'package:flutter/material.dart';
import 'donor/donor_login.dart';
import 'donor/donor_register.dart';
import 'package:lifelink/screens/hospital/hospital_login.dart';
import 'package:lifelink/screens/hospital/hospital_register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeLink Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.redAccent, // A slightly softer red
        elevation: 0, // Remove shadow for a cleaner look
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDE2E2), // Light red
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.all(32.0), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            const Text(
              "Welcome to LifeLink",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Text(
              "Login as:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonorLogin()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Donor Login"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonorRegister()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Donor Register"),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey), // Added a divider
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HospitalLoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Different color for hospitals
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Hospital Login"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HospitalRegisterPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Hospital Register"),
            ),
          ],
        ),
      ),
    );
  }
}