import 'package:flutter/material.dart';

import 'widgets/signup_screen_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignUpScreenBody(),
    );
  }
}
