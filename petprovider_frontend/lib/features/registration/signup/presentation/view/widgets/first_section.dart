import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/utils/theming/styles.dart';

// import 'signup_username_widget.dart';

class FirstSection extends StatelessWidget {
  const FirstSection({
    super.key, required this.title, required this.subTitle,
  });
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Styles.styles22BoldGreen,
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text(
            subTitle,
            style: Styles.styles12NormalHalfBlack,
          ),
        ),
        SizedBox(height: 14.h),
        // const SignUpUserNameWidget(),
      ],
    );
  }
}
