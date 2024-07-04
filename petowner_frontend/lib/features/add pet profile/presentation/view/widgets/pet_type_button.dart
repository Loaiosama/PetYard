import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class PetTypeButton extends StatelessWidget {
  final String type;
  final String imagePath;
  final void Function()? onTap;
  const PetTypeButton(
      {super.key, required this.type, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: kPrimaryGreen),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                type,
                style: Styles.styles18MediumWhite,
              ),
              Image.asset(
                imagePath,
              ),
            ],
          )),
    );
  }
}
