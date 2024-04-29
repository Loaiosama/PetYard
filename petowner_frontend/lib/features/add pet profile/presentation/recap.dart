import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/recap_details.dart';

class Recap extends StatelessWidget {
  final PetModel petModel;
  const Recap({super.key, required this.petModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18.sp,
            )),
        backgroundColor: Colors.transparent,
        title: Text(
          "your Pet profile",
          style: Styles.styles18MediumWhite,
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: kPrimaryGreen,
      body: RecapDetails(
        petModel: petModel,
      ),
    );
  }
}
