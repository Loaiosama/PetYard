import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key, required this.service, required this.type});
  final String service;
  final String type;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200.h,
          width: 200.w,
          child: SvgPicture.asset(
            'assets/svgs/sad_pet.svg',
            fit: BoxFit.cover,
          ),
        ),
        heightSizedBox(10),
        Text(
          'There is no $service $type.',
          style: Styles.styles12NormalHalfBlack,
        ),
      ],
    );
  }
}
