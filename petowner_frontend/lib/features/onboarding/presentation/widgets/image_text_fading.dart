import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class BackGroundImageAndTextWithFading extends StatelessWidget {
  const BackGroundImageAndTextWithFading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.0),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.16, 0.5],
            ),
          ),
          child: Image.asset('${Constants.assetsImage}/onBoarding_dog.png'),
        ),
        Positioned(
          bottom: 20,
          left: 0.0,
          right: 0.0,
          child: Center(
            child: Text(
              'Personalized Pet Profiles',
              style: Styles.styles22.copyWith(color: kPrimaryGreen),
            ),
          ),
        ),
      ],
    );
  }
}
