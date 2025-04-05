import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'donor_dashboard.dart';

class DonorRegister extends StatefulWidget {
  const DonorRegister({super.key});

  @override
  State<DonorRegister> createState() => _DonorRegisterState();
}

class _DonorRegisterState extends State<DonorRegister> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  Future<void> _register() async {
    setState(() => _isLoading = true);

    final error = await _authService.registerDonor(_email.text.trim(), _password.text.trim());

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
      appBar: AppBar(title: const Text("Donor Register")),
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
                    onPressed: _register,
                    child: const Text("Register"),
                  ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
