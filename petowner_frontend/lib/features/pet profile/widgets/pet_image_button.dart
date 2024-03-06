import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

class RPetImageButton extends StatelessWidget {
  const RPetImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color : Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: (){},
        splashColor: Colors.black26,
        child: Row(
          
          children: [
           Ink.image(
            
            image: AssetImage(Constants.catImage) ,
            height: 150,
            width: 150,
            fit: BoxFit.fill,
            ),
            SizedBox(
              width: 30.w,
            ),
            const Text(
              'Cat',
            ),
            SizedBox(
              width: 30.w,
            )
          ]
        ),
      ),
    );
  }
}
class LPetImageButton extends StatelessWidget {
  const LPetImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color :Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: (){},
        splashColor: Colors.black26,
        child: Row(
          
          children: [
           
            SizedBox(
              width: 30.w,
            ),
            const Text(
              'Dog',
            ),
            SizedBox(
              width: 30.w,
            ),
            Ink.image(
            
            image: AssetImage(Constants.dogImage) ,
            height: 150,
            width: 150,
            fit: BoxFit.fill,
            ),
          ]
        ),
      ),
    );
   
  }
}