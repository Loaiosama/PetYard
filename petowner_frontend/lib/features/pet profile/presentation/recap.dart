import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/recap_details.dart';

class Recap extends StatelessWidget {
  final PetModel petModel;
  const Recap({super.key, required this.petModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "your Pet profile",
          style: Styles.styles18MediumWhite,
        ),
        centerTitle: true,
      ),
      backgroundColor: kPrimaryGreen,
      body: RecapDetails(
        petModel: petModel,
      ),
    );
  }
}
