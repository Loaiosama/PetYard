import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class TypeTile extends StatelessWidget {
  final String type;
  final String imagePath;
  final void Function()? onTap;
  const TypeTile(
      {super.key,
      required this.type,
      required this.imagePath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          color: kSecondaryGreen,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: kPrimaryGreen),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            height: 100.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  type,
                  style: Styles.styles14NormalBlack
                      .copyWith(color: Colors.white, height: 3, fontSize: 25),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Image.asset(
                  imagePath,
                  width: 70.w,
                  height: 70.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
