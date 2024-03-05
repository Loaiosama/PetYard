import 'package:flutter/material.dart';
import 'package:petowner_frontend/features/splash/widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {


  const SplashView({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: SplashViewBody(),
    );
  }
}