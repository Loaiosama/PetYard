import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/linear_percent_indecator.dart';

import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/pet_image_button.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/pet_type_bar.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/pet_type_button.dart';

class ChooseType extends StatelessWidget {
  const ChooseType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0.r) , 
                  bottomRight: Radius.circular(30.0.r),
                ),
                color: kPrimaryGreen ,
              ),
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height*0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/dog_and_cat_5.png" ,
                    width: 350.w,
                    height: 350.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Choose Your Pet Type " , 
                        style: Styles.styles14NormalBlack.copyWith(height: 3 ,fontWeight: FontWeight.bold , fontSize: 16),
                        
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset(
                        "assets/images/happy_dog.png",
                        width: 40,
                        height: 40,
                        
                      )
                    ],
                  ),
                ],
              ) ,
            ),
            SizedBox(
              height: 30.h,
            ), 
             Column(
              children: [
                const PetTypeButton(type: 'Cat' , imagePath: "assets/images/cat_type.png"),
                SizedBox(
                  height: 20.h,
                ),
                const PetTypeButton(type: 'Dog' , imagePath: "assets/images/dog_type.png",)
              ],
            )


          ],
        ),
      ),
    );
  }
}
