import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class ServiceReqTile extends StatelessWidget {
  final String title ; 
  final String subTitle ; 
  final String imagePath ; 
  const ServiceReqTile({
    super.key, required this.title, required this.subTitle, required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 10.0),
      child: Card(
        elevation: 3,
        shape : RoundedRectangleBorder(
          side : const BorderSide(
            color : kPrimaryGreen,
            width: 1,
    
          ),
          borderRadius: BorderRadius.circular(16)
        ),
        
        color: Colors.grey[200],
        child: SizedBox(
          height: 110.h,
          child: ListTile(
          
            title:Text(
              title, 
              style: Styles.styles18RegularBlack,
              ),
              subtitle: Text(
                subTitle , 
                style: Styles.styles14NormalBlack.copyWith(color: Colors.grey[700]),
              ),
              trailing: Image.asset(imagePath),
          
          ),
        ),
      ),
    );
  }
}