import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    this.height = 50.0,
    this.radius = 12.0,
  });
  final double? height;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: kPrimaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius!.r),
        ),
        minimumSize: Size(double.infinity, height!.h),
      ),
      child: Center(
        child: SizedBox(
          height: 20.sp,
          width: 20.sp,
          child: const CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
