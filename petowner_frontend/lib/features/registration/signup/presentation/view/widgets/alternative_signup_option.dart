import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class ALternativeSignupOptionColumn extends StatelessWidget {
  const ALternativeSignupOptionColumn({
    super.key,
    this.isSignUp = true,
  });

  final bool isSignUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: const Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Text(
                isSignUp ? 'Or sign up with' : 'Or sign in with',
                style: Styles.styles12NormalHalfBlack,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: const Divider(),
            ),
          ],
        ),
        Center(
          child: Column(
            children: [
              // Text(
              //   'Sign up with',
              //   style: Styles.styles16,
              // ),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.black.withOpacity(0.3), width: 1.w),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        AssetImage('${Constants.assetsImage}/google_logo.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
        heightSizedBox(16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'By logging, you agree to our ',
                style: Styles.styles12NormalHalfBlack.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                ),
                children: [
                  TextSpan(
                    text: 'Terms & Conditions ',
                    style: Styles.styles10w400.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                  const TextSpan(
                    text: 'and ',
                  ),
                  TextSpan(
                    text: 'PrivacyPolicy.',
                    style: Styles.styles10w400.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  )
                ]),
          ),
        ),
        heightSizedBox(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isSignUp ? 'Already have an account?' : "Don't have an account?",
              style: Styles.styles12NormalHalfBlack
                  .copyWith(decoration: TextDecoration.underline),
            ),
            TextButton(
                onPressed: () {
                  isSignUp
                      ? GoRouter.of(context).push(Routes.kSigninScreen)
                      : GoRouter.of(context).push(Routes.kSignupScreen);
                },
                child: Text(
                  isSignUp ? 'Sign in!' : 'Sign up!',
                  style: Styles.styles12NormalHalfBlack.copyWith(
                    color: Colors.blue,
                  ),
                )),
          ],
        )
      ],
    );
  }
}
