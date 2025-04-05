import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'donor_dashboard.dart';

class DonorRegister extends StatefulWidget {
  const DonorRegister({super.key});

  @override
  State<DonorRegister> createState() => _DonorRegisterState();
}

class _DonorRegisterState extends State<DonorRegister> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _selectedBloodType;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final error = await _authService.registerDonor(
        _email.text.trim(),
        _password.text.trim(),
        _name.text.trim(),
        _selectedBloodType!,
      );

      if (error == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DonorDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("Donor Registration"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Join LifeLink!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _name,
                icon: Icons.person,
                label: "Full Name",
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your full name'
                    : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _email,
                icon: Icons.email,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _password,
                icon: Icons.lock,
                label: "Password",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                decoration: InputDecoration(
                  labelText: 'Blood Type',
                  prefixIcon: const Icon(Icons.bloodtype),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() {
                          _selectedBloodType = value;
                        }),
                validator: (value) =>
                    value == null ? 'Please select a blood type' : null,
              ),
              const SizedBox(height: 30),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Register",
                          style:
                              TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
