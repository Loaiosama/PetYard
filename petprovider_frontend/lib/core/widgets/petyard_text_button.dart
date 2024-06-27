import 'package:flutter/material.dart';

import '../utils/theming/colors.dart';
// import 'package:go_router/go_router.dart';
// import 'package:petowner_frontend/core/utils/routing/app_router.dart';
// import 'package:petowner_frontend/core/utils/routing/routes.dart';


class PetYardTextButton extends StatelessWidget {
  const PetYardTextButton({
    super.key,
    this.width = double.infinity,
    this.height = 60,
    this.radius = 10,
    this.color = kPrimaryGreen,
    this.style,
    this.text = 'Sign up!',
    required this.onPressed,
    this.borderColor = Colors.transparent,
  });
  final double width;
  final double height;
  final double radius;
  final Color color;
  final Color? borderColor;
  final TextStyle? style;
  final String text;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: borderColor!),
        ),
        minimumSize: Size(width, height),
      ),
      child: Center(
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
