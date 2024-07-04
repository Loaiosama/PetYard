import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

class PersonalInformationImage extends StatelessWidget {
  const PersonalInformationImage({super.key, this.isEdit = false});

  final bool? isEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132.0.w, // Add additional width to accommodate the border
      height: 132.0.h, // Add additional height to accommodate the border
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: kPrimaryGreen, // Change border color to green
          width: 2.0.w,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          width: 130.0.w,
          height: 130.0.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage('assets/images/1.png'),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: Colors.white,
              width: 4.0.w,
            ),
          ),
          child: isEdit!
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 34.w,
                    height: 34.h,
                    margin: EdgeInsets.only(top: 40.0.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 4.0.w,
                      ),
                      shape: BoxShape.circle,
                      color: const Color.fromRGBO(248, 248, 248, 1),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Center(
                        child: Icon(
                          FontAwesomeIcons.penToSquare,
                          size: 13.sp,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
