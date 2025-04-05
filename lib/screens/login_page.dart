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
        title: const Text('LifeLink Login'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text("Login as:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DonorLogin()));
              },
              child: const Text("Donor Login"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DonorRegister()));
              },
              child: const Text("Donor Register"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
  onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalLoginPage()));
  },
  child: const Text("Hospital Login"),
),
ElevatedButton(
  onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalRegisterPage()));
  },
  child: const Text("Hospital Register"),
),

          ],
        ),
      ),
    );
  }
}
