import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/date_picker.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/gender.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/linear_percent_indecator.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/pet_type_bar.dart';
// import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/pet_weight_item.dart';

class PetInfo extends StatefulWidget {
  final PetModel petModel;

  const PetInfo({
    super.key,
    required this.petModel,
  });

  @override
  PetInfoState createState() => PetInfoState();
}

class PetInfoState extends State<PetInfo> {
  String selectedWeight = '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                      heightSizedBox(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Enter your pet name',
                          style: Styles.styles14w600,
                        ),
                      ),
                      SizedBox(height: 15.h),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your pet name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Enter your pet weight',
                          style: Styles.styles14w600,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     PetWeightItem(
                        //       text: 'Under 3 kg',
                        //       isSelected: selectedWeight == 'Under 3 kg',
                        //       onSelect: (isSelected) {
                        //         setState(() {
                        //           selectedWeight =
                        //               isSelected ? 'Under 3 kg' : '';
                        //           widget.petModel.weight = '3';
                        //           // widget.petModel.image = 'default.png';
                        //         });
                        //       },
                        //     ),
                        //     PetWeightItem(
                        //       text: '3-5kg',
                        //       isSelected: selectedWeight == '3-5kg',
                        //       onSelect: (isSelected) {
                        //         setState(() {
                        //           selectedWeight = isSelected ? '3-5kg' : '';
                        //           widget.petModel.weight = '4';
                        //         });
                        //       },
                        //     ),
                        //     PetWeightItem(
                        //       text: 'over 5kg',
                        //       isSelected: selectedWeight == 'over 5kg',
                        //       onSelect: (isSelected) {
                        //         setState(() {
                        //           selectedWeight = isSelected ? 'over 5kg' : '';
                        //           widget.petModel.weight = '5';
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                        child: CustomRegistrationTextField(
                          width: double.infinity,
                          hintText: 'Your pet weight',
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              widget.petModel.weight = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your pet name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'What\'s the gender of your pet?',
                          style: Styles.styles14w600,
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
                      heightSizedBox(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: DatePicker(
                          labelText: 'Date of birth',
                          onDateSelected: (date) {
                            setState(() {
                              widget.petModel.dateOfBirth = date;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select a date of birth';
                            }
                            return null;
                          },
                        ),
                      ),
                      heightSizedBox(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: DatePicker(
                          labelText: 'Adoption Date',
                          onDateSelected: (date) {
                            setState(() {
                              widget.petModel.adoptionDate = date;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select an adoption date';
                            }
                            return null;
                          },
                        ),
                      ),
                      heightSizedBox(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: bioController,
                          maxLines: 5,
                          minLines: 2,
                          decoration: InputDecoration(
                            hintText: 'About My Pet',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 14.sp,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: const BorderSide(
                                color: kPrimaryGreen,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your bio';
                            }
                            return null;
                          },
                        ),
                      ),
                      heightSizedBox(30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: PetYardTextButton(
                          height: 50.h,
                          text: 'Continue',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.petModel.name = nameController.text;
                              widget.petModel.bio = bioController.text;
                              widget.petModel.weight = weightController.text;
                              if (widget.petModel.weight!.isEmpty ||
                                  widget.petModel.gender!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please Enter your pet weight and gender.')));
                              } else {
                                // print(widget.petModel.weight);
                                context.pushNamed(Routes.kPetRecap,
                                    extra: widget.petModel);
                              }
                            }
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
      ),
    );
  }
}
