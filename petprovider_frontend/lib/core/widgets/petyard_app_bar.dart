import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../utils/theming/colors.dart';
import '../utils/theming/styles.dart';

class PetYardAppBar extends StatelessWidget {
  const PetYardAppBar(
      {super.key,
      required this.title,
      this.icon,
      this.onPressed,
      this.actionText = ''});

  final String title;
  final IconData? icon;
  final void Function()? onPressed;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (icon != null)
          ? EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 14.0.w)
          : EdgeInsets.only(top: 18.0.h, left: 14.0.w, bottom: 18.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              GoRouter.of(context).pop();
            },
            child: Container(
              width: 46.w,
              height: 46.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withOpacity(0.1),
                  width: 1.0.w,
                ),
                borderRadius: BorderRadius.circular(12.0.r),
                // shape: BoxShape.circle,
                color: const Color.fromRGBO(248, 248, 248, 1),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          Text(
            title,
            style: Styles.styles16w600,
          ),
          (icon != null)
              ? IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    icon,
                    color: Colors.black,
                    size: 22.sp,
                  ),
                )
              : TextButton(
                  onPressed: onPressed,
                  child: Text(
                    actionText!,
                    style: Styles.styles16w600.copyWith(color: kPrimaryGreen),
                  ),
                ),
        ],
      ),
    );
  }
}
