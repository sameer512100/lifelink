import 'package:flutter/material.dart';
import 'package:lifelink/screens/hospital/hospital_dashboard.dart';
import 'package:lifelink/services/auth_service.dart';

class HospitalRegisterPage extends StatefulWidget {
  const HospitalRegisterPage({super.key});

  @override
  State<HospitalRegisterPage> createState() => _HospitalRegisterPageState();
}

class _HospitalRegisterPageState extends State<HospitalRegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _registerHospital() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final result = await _authService.registerHospital(email, password);

    if (result == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HospitalDashboard(hospitalName: name),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: $result"),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospital Registration"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.local_hospital, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 20),
                Text(
                  "Register Your Hospital",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Hospital Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Hospital Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.local_hospital),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter hospital name" : null,
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter your email';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter your password';
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Register Button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _registerHospital,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Already have an account? Login here",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
