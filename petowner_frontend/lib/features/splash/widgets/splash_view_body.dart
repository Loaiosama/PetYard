import 'package:flutter/material.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

import 'package:petowner_frontend/features/registration/signup/presentation/signup.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/test.png'),
      // nextScreen: GoRouter.of(context).pushNamed(Routes.kSignupScreen),
      nextScreen: const SignUpScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: kPrimaryGreen,
      splashIconSize: 700,
    );
  }
}
