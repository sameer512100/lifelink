import 'package:flutter/material.dart';
import 'package:lifelink/screens/hospital/hospital_dashboard.dart';
import 'package:lifelink/services/auth_service.dart';

class HospitalRegisterPage extends StatefulWidget {
  const HospitalRegisterPage({super.key});

  @override
  State<HospitalRegisterPage> createState() => _HospitalRegisterPageState();
}

class _HospitalRegisterPageState extends State<HospitalRegisterPage> {
  final TextEditingController _nameController = TextEditingController(); // ✅ Hospital name
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

  final name = _nameController.text.trim();
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (name.isEmpty || email.isEmpty || password.isEmpty) {
    setState(() {
      _isLoading = false;
      _error = "Please fill all fields.";
    });
    return;
  }

  final result = await _authService.registerHospital(email, password);

  setState(() => _isLoading = false);

  if (result != null) {
    setState(() => _error = "Registration failed. Try again.");
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HospitalDashboard(hospitalName: name), // ✅ passed name here
      ),
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
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Hospital Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _isLoading ? null : _registerHospital,
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
