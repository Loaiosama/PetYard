import 'package:flutter/material.dart';

import 'package:petowner_frontend/core/utils/theming/colors.dart';

class PetYardTextButton extends StatelessWidget {
  const PetYardTextButton({
    super.key,
    this.width = double.infinity,
    this.height = 60,
    this.radius = 10,
    this.color = kPrimaryGreen,
    this.style,
  });
  final double width;
  final double height;
  final double radius;
  final Color color;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        minimumSize: Size(width, height),
      ),
      child: Center(
        child: Text(
          'Sign up!',
          style: style,
        ),
      ),
    );
  }
}
