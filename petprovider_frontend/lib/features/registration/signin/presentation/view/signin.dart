import 'package:flutter/material.dart';

import 'widgets/signin_screen_body.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignInScreenBody(),
    );
  }
}
