import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const LifeLinkApp());
}

class LifeLinkApp extends StatelessWidget {
  const LifeLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeLink',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
