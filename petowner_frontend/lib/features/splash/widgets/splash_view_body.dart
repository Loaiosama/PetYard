import 'package:flutter/material.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:petowner_frontend/features/registration/signup/presentation/signup.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/splash_screen 2.png'), 
      nextScreen: const SignUpScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: const Color.fromRGBO(0, 191, 99, 1),
      splashIconSize: 500,
  
      );
  }
}