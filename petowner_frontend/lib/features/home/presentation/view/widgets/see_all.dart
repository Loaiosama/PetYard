import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class SeeAllRow extends StatelessWidget {
  const SeeAllRow({super.key, required this.title, required this.onPressed});

  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Styles.styles18SemiBoldBlack,
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'See All',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
