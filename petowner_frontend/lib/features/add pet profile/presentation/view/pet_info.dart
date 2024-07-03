import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/add_pet_image.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/date_picker.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/gender.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/linear_percent_indecator.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/pet_type_bar.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/pet_weight_item.dart';

class PetInfo extends StatefulWidget {
  final PetModel petModel;
  const PetInfo({
    super.key,
    required this.petModel,
  });
  @override
  // ignore: library_private_types_in_public_api
  _PetInfoState createState() => _PetInfoState();
}

class _PetInfoState extends State<PetInfo> {
  String selectedWeight = '';
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const PetTypeBar(subtitle: 'Add pet profile', step: '3'),
            SizedBox(height: 5.h),
            const LinearIndicator(percent: 0.5),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AddPetPhoto(),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CustomRegistrationTextField(
                        width: double.infinity,
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Enter your pet weight',
                        style: Styles.styles14NormalBlack,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PetWeightItem(
                            text: 'Under 3 kg',
                            isSelected: selectedWeight == 'Under 3 kg',
                            onSelect: (isSelected) {
                              setState(() {
                                selectedWeight = isSelected ? 'Under 3 kg' : '';
                                widget.petModel.weight = '3';
                                widget.petModel.image = 'default.png';
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'What\'s the gender of your pet?',
                        style: Styles.styles14NormalBlack,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Gender(onGenderSelected: (gender) {
                        setState(() {
                          widget.petModel.gender = gender;
                        });
                      }),
                    ),
                    // SizedBox(
                    //   height: 15.h,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: Text(
                    //     'Date of Birth',
                    //     style: Styles.styles14NormalBlack,
                    //   ),
                    // ),
                    heightSizedBox(15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DatePicker(
                        labelText: 'Date of birth',
                        onDateSelected: (date) {
                          setState(() {
                            widget.petModel.dateOfBirth = date;
                          });
                        },
                      ),
                    ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: Text(
                    //     'Adoption Date',
                    //     style: Styles.styles14NormalBlack,
                    //   ),
                    // ),
                    heightSizedBox(15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Enter your pet bio',
                          enabledBorder: customEnabledOutlinedBorder,
                          focusedBorder: customFocusedOutlinedBorder,
                          errorBorder: customErrorOutlinedBorder,
                        ),
                        onChanged: (value) {
                          // Handle the text input
                        },
                      ),
                    ),
                    heightSizedBox(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: PetYardTextButton(
                        // height: 44.h,
                        // width: 50.w,
                        height: 50.h,
                        text: 'Continue',
                        onPressed: () {
                          widget.petModel.name = nameController.text;

                          context.pushNamed(Routes.kPetRecap,
                              extra: widget.petModel);
                        },
                        style: Styles.styles14NormalBlack
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
