import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/pet%20profile/data/pet_model.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/add_pet_image.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/date_picker.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/gender.dart';

import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/linear_percent_indecator.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/pet_type_bar.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/pet_weight_item.dart';

class PetInfo extends StatefulWidget {
  final PetModel petModel;
  const PetInfo({
    Key? key,
    required this.petModel,
  }) : super(key: key);
  @override
  _PetInfoState createState() => _PetInfoState();
}

class _PetInfoState extends State<PetInfo> {
  String selectedWeight = '';
  final TextEditingController nameController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PetTypeBar(subtitle: 'Add pet profile', step: '3'),
              SizedBox(height: 5.h),
              const LinearIndicator(percent: 0.5),
              SizedBox(height: 20.h),
              const AddPetPhoto(),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: CustomRegistrationTextField(
                  width: 300.w,
                  hintText: 'Your pet name',
                  controller: nameController,
                  onChanged: (value) {
                    setState(() {
                      widget.petModel.name = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Enter your pet weight',
                  style: Styles.styles14NormalBlack,
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PetWeightItem(
                      text: 'Under 3 kg',
                      isSelected: selectedWeight == 'Under 3 kg',
                      onSelect: (isSelected) {
                        setState(() {
                          selectedWeight = isSelected ? 'Under 3 kg' : '';
                        });
                      },
                    ),
                    PetWeightItem(
                      text: '3-5kg',
                      isSelected: selectedWeight == '3-5kg',
                      onSelect: (isSelected) {
                        setState(() {
                          selectedWeight = isSelected ? '3-5kg' : '';
                        });
                      },
                    ),
                    PetWeightItem(
                      text: 'over 5kg',
                      isSelected: selectedWeight == 'over 5kg',
                      onSelect: (isSelected) {
                        setState(() {
                          selectedWeight = isSelected ? 'over 5kg' : '';
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'What’s the gender of your pet?',
                  style: Styles.styles14NormalBlack,
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Gender(onGenderSelected: (gender) {
                  setState(() {
                    widget.petModel.gender = gender;
                  });
                }),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: DatePicker(
                  labelText: 'Date of birth',
                  onDateSelected: (date) {
                    setState(() {
                      widget.petModel.dateOfBirth = date;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: DatePicker(
                  labelText: 'Adoption Date',
                  onDateSelected: (date) {
                    setState(() {
                      widget.petModel.adoptionDate = date;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: PetYardTextButton(
                  width: 50.w,
                  text: 'Continue',
                  onPressed: () {
                    widget.petModel.name = nameController.text;

                    context.pushNamed(Routes.kPetRecap, extra: widget.petModel);
                  },
                  style:
                      Styles.styles14NormalBlack.copyWith(color: Colors.white),
                ),
              ),
            ]),
      ),
    );
  }
}
