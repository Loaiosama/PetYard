import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

class LinearIndicator extends StatelessWidget {
  final double percent;

  const LinearIndicator({
    super.key,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 3.h,
      percent: percent,
      progressColor: kPrimaryGreen,
      barRadius: Radius.circular(8.r),
    );
  }
}
