import 'dart:async';
import 'package:flutter/material.dart';
import '../services/local_store.dart';
import 'onboarding_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.store});
  final LocalStore store;
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override void dispose() { _timer?.cancel(); super.dispose(); }
  @override void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>
        widget.store.introSeen ? MainShell(store: widget.store) : OnboardingScreen(store: widget.store)));
    });
  }
  @override Widget build(BuildContext context) => Scaffold(
    body: Container(width: double.infinity,
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4A237E), Color(0xFF9A65FF)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.water_damage_outlined, size: 78, color: Colors.white),
        SizedBox(height: 12), Text('AlertaJá', style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 8), Text('Informação local. Comunidade preparada.', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 30), SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
      ]),
    ),
  );
}
