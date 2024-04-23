import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/pet%20profile/data/pet_model.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/linear_percent_indecator.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/pet_image.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/pet_type_bar.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/reap_item.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/recap_details.dart';

class Recap extends StatelessWidget {
  final PetModel petModel  ; 
  const Recap({super.key, required this.petModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      
        title: Text(
          "your Pet profile" , 
           style: Styles.styles18MediumWhite,
           
        ),
        centerTitle: true,
      ),
      backgroundColor: kPrimaryGreen,
      body:RecapDetails(petModel: petModel,),  
        );
      
    
  }
}