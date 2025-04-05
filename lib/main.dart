import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/donor/donor_login.dart';
import 'screens/donor/donor_register.dart';
import 'screens/hospital/hospital_login.dart';
import 'screens/hospital/hospital_register.dart';
import 'screens/donor/donor_dashboard.dart';
import 'screens/hospital/hospital_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase initialized
  runApp(const LifeLinkApp());
}

class LifeLinkApp extends StatelessWidget {
  const LifeLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeLink',
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Start at LoginPage
      routes: {
        '/': (context) => const LoginPage(),

        // Donor routes
        '/donorLogin': (context) => const DonorLogin(),
        '/donorRegister': (context) => const DonorRegister(),
        '/donorDashboard': (context) => const DonorDashboard(),

        // Hospital routes
        '/hospitalLogin': (context) => const HospitalLoginPage(),
        '/hospitalRegister': (context) => const HospitalRegisterPage(),
        '/hospitalDashboard': (context) => const HospitalDashboard(),
      },
    );
  }
}
