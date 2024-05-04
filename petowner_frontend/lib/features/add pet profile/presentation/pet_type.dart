import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/type_tile.dart';

class ChooseType extends StatelessWidget {
  
  const ChooseType({super.key,});

  @override
  Widget build(BuildContext context) {
     PetModel petModel = PetModel() ;
    return  Scaffold(

      body : SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Choose your pet type" , 
                style: Styles.styles22BoldGreen,
              ),
              SizedBox(
                height: 25.h,
              ) , 
               TypeTile(type: "Dog", imagePath: "assets/images/klb_b_3adma.png" , onTap: (){
                petModel.type = "Dog";
               
               }, ),
               TypeTile(type: "Cat", imagePath: "assets/images/cool_cat.png" , onTap: (){
             
                petModel.type = "Cat";
                context.pushNamed(Routes.kPetBreed, extra: petModel) ; 
               } ,),
          
            ],
            ),
        ),
      ),

    );
  }
}
