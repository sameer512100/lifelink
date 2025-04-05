import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'donor_dashboard.dart';

class DonorLogin extends StatefulWidget {
  const DonorLogin({super.key});

  @override
  State<DonorLogin> createState() => _DonorLoginState();
}

class _DonorLoginState extends State<DonorLogin> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final error = await _authService.loginDonor(_email.text.trim(), _password.text.trim());

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DonorDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donor Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: "Email")),
            TextField(
              controller: _password,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text("Login"),
                  ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/donorRegister'),
              child: const Text("Don't have an account? Register here"),
            ),
          ],
        ),
      ),
    );
  }
}
