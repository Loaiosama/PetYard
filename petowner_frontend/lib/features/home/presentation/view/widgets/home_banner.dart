
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0.r),
        color: kPrimaryGreen,
      ),
      child: Stack(
        children: [
          Center(
            child: ClipRect(
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: 40 * 3.1415927 / 180,
                  child: Container(
                    width: 100.w,
                    height: 400.h,
                    color: Colors.black.withOpacity(0.05),
                    child: Transform.rotate(
                      angle: 70 * 3.1415927 / 180,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 14.0, right: 14.0, top: 20.0, bottom: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: Text(
                          'Book and schedule with pet carer.',
                          style: Styles.styles18MediumWhite
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      heightSizedBox(16),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Find Nearby',
                          style: Styles.styles18MediumWhite
                              .copyWith(color: Colors.blueAccent,fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  'assets/svgs/pet_sitting_home.svg',
                  height: 180.h,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
