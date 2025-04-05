import 'package:flutter/material.dart';
import 'package:lifelink/screens/hospital/hospital_dashboard.dart';
import 'package:lifelink/services/auth_service.dart';

class HospitalRegisterPage extends StatefulWidget {
  const HospitalRegisterPage({super.key});

  @override
  State<HospitalRegisterPage> createState() => _HospitalRegisterPageState();
}

class _HospitalRegisterPageState extends State<HospitalRegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;

  void _registerHospital() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _authService.registerDonor(  // 🔁 reuse donor method for now
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result != null) {
      setState(() => _error = "Registration failed. Try again.");
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HospitalDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hospital Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _isLoading ? null : _registerHospital,
              child: _isLoading ? const CircularProgressIndicator() : const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
