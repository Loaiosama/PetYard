import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreenCenteredImage extends StatelessWidget {
  const ProfileScreenCenteredImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0.w,
      height: 120.0.h,
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
      child: Align(
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
      ),
    );
  }
}
