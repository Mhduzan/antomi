import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const AndomiApp());
}

class AndomiApp extends StatelessWidget {
  const AndomiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andomi - Belajar Anatomi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}