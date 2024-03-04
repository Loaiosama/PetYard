import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/widgets/test.dart';

void main() {
  runApp(const PetYardApp());
}

class PetYardApp extends StatelessWidget {
  const PetYardApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestScreen(),
    );
  }
}
