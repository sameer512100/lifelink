import 'package:flutter/material.dart';
import 'package:lifelink/screens/hospital/hospital_dashboard.dart';
import 'package:lifelink/services/auth_service.dart';

class HospitalLoginPage extends StatefulWidget {
  const HospitalLoginPage({super.key});

  @override
  State<HospitalLoginPage> createState() => _HospitalLoginPageState();
}

class _HospitalLoginPageState extends State<HospitalLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;

  void _loginHospital() async {
  setState(() {
    _isLoading = true;
    _error = null;
  });

  final result = await _authService.loginDonor(
    _emailController.text.trim(),
    _passwordController.text.trim(),
  );

  setState(() => _isLoading = false);

  if (result == null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HospitalDashboard(
          hospitalName: _emailController.text.trim(), // ✅ Pass dynamic name here
        ),
      ),
    );
  } else {
    setState(() => _error = result);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hospital Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _isLoading ? null : _loginHospital,
              child: _isLoading ? const CircularProgressIndicator() : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
