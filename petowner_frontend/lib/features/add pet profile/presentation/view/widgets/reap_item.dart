import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class RecapItem extends StatelessWidget {
  final IconData iconData;
  final String primaryText;
  final String secondaryText;

  const RecapItem({
    super.key,
    required this.iconData,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData, color: kPrimaryGreen),
        title: Text(primaryText, style: Styles.styles14NormalBlack),
        trailing: Text(
          secondaryText,
          style: Styles.styles14NormalBlack,
        ),
      ),
    );
  }
}
