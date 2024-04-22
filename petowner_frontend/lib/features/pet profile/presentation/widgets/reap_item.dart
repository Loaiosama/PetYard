import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class RecapItem extends StatelessWidget {
  final IconData iconData;
  final String primaryText;
  final String secondaryText;

  const RecapItem({
    Key? key,
    required this.iconData,
    required this.primaryText,
    required this.secondaryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        
        
        border: Border.all(
          
          color: Colors.white,
          width: 2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData , color : kPrimaryGreen) ,
        title: Text(primaryText , style : Styles.styles14NormalBlack),
        trailing: Text(secondaryText , style: Styles.styles14NormalBlack,),
            
      ),
    );
  }
}
