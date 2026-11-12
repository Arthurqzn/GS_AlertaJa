import 'package:flutter/material.dart';
import 'services/local_store.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

class AlertaJaApp extends StatelessWidget {
  const AlertaJaApp({super.key, required this.store});
  final LocalStore store;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'AlertaJá • Dark Neon',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: SplashScreen(store: store),
  );
}
