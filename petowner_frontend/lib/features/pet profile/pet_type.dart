import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/pet%20profile/widgets/linear_percent_indecator.dart';

import 'package:petowner_frontend/features/pet%20profile/widgets/pet_image_button.dart';
import 'package:petowner_frontend/features/pet%20profile/widgets/pet_type_bar.dart';

class ChooseType extends StatefulWidget {
  const ChooseType({super.key});

  @override
  State<ChooseType> createState() => _ChooseTypeState();
}

class _ChooseTypeState extends State<ChooseType> {
  bool isHover = false ; 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[200],
   
    
      body:  Column(
        children: [
         const PetTypeBar(),
          SizedBox(
            height: 10.h,
          ),
          const LinearIndicator(percent: 0.2,),
        
           SizedBox(
            height: 20.h,
          ),

           Text(
            'Choose the type of your pet',
            style: Styles.styles20
          ) , 

           SizedBox(
            height: 70.h,
          ),

         
         const  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RPetImageButton(),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
         const  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LPetImageButton(),
            ],
          ),
          
        
             
    
              
            
           
          

        
         
          
        ],
      ),
      
 

      
    );
  }
}