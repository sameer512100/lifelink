import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lifelink/screens/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _iconAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeIn,
    );

    _iconAnimationController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeInAnimation,
              child: const Icon(
                Icons.favorite,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'LIFELINK',
                  textStyle: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ],
        ),
      ),
    );
  }
}
