import 'package:flutter/material.dart';
// import 'package:petowner_frontend/core/widgets/test.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/signup.dart';
import 'package:petowner_frontend/features/splash/splash_view.dart';

void main() {
  runApp(const PetYardApp());
}

class PetYardApp extends StatelessWidget {
  const PetYardApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
      theme: ThemeData.light().copyWith(
          // scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          ),
    );
  }
}
