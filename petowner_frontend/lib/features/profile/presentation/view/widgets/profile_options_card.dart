import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/theming/fonts_helper.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class ProfileOptionsCard extends StatelessWidget {
  const ProfileOptionsCard({
    super.key,
    required this.cardColor,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.route,
  });

  final String route;
  final Color cardColor;
  final Color iconColor;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.0.h),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).push(route);
        },
        child: Column(
          children: [
            Material(
              color: Colors.white,
              // elevation: 2,
              // borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 6.h, left: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.0.r),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: iconColor,
                          size: 14.sp,
                        ),
                      ),
                    ),
                    // widthSizedBox(10),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        label,
                        style: Styles.styles16w600.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontsHelper.regular,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black.withOpacity(0.4),
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
