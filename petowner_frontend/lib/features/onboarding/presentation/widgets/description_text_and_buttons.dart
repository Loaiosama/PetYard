import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';

class DescriptionTextAndButtonsColumn extends StatelessWidget {
  const DescriptionTextAndButtonsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.0.w),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Text(
              'Create personalized profiles for each of your beloved pets on PetYard. Share their name, breed, and age while connecting with a vibrant community. ',
              style: Styles.styles12,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 18.0.w, top: 20.h, right: 18.w),
          child: PetYardTextButton(
            onPressed: () {
              GoRouter.of(context).push(Routes.kSignupScreen);
            },
            text: 'Get Started',
            style: Styles.styles16.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            GoRouter.of(context).push(Routes.kChooseType);
          },
          child: Text(
            'Sign up later',
            style: Styles.styles14.copyWith(
              color: Colors.grey,
              decoration: TextDecoration.underline,
              decorationColor:
                  Colors.grey, // Customize the color of the underline
              decorationThickness: 2,
            ),
          ),
        ),
      ],
    );
  }
}
