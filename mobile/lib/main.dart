import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const RamaniApp());
}

class RamaniApp extends StatelessWidget {
  const RamaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NIT Ramani',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
