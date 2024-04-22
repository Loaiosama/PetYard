import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/personal_information_cubit/personal_information_cubit.dart';
import '../../../../core/utils/theming/colors.dart';
import 'widgets/personal_information_image.dart';
import 'widgets/personal_information_text_field.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalInformationCubit(),
      child: BlocBuilder<PersonalInformationCubit, PersonalInformationState>(
        builder: (context, state) {
          PersonalInformationCubit cubit = BlocProvider.of(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              title: Text(
                'Personal Information',
                style: Styles.styles18RegularBlack,
              ),
              centerTitle: true,
              actions: [
                !cubit.isEdit
                    ? TextButton(
                        onPressed: () {
                          cubit.edit();
                        },
                        child: Text(
                          'Edit',
                          style: Styles.styles16w600.copyWith(
                              color: kPrimaryGreen,
                              fontWeight: FontWeight.w500),
                        ))
                    : Container(),
              ],
            ),
            body: Padding(
              padding:
                  EdgeInsets.only(left: 20.0.w, right: 20.0.w, bottom: 20.0.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PersonalInformationImage(
                      isEdit: cubit.isEdit,
                    ),
                    heightSizedBox(12),
                    PersonalInformationTextField(
                      controller: cubit.emailController,
                      isEdit: cubit.isEdit,
                      label: 'Email Address',
                      isEmail: true,
                    ),
                    heightSizedBox(20),
                    PersonalInformationTextField(
                      controller: cubit.fNameController,
                      isEdit: cubit.isEdit,
                      label: 'FirstName',
                    ),
                    heightSizedBox(20),
                    PersonalInformationTextField(
                      controller: cubit.lNameController,
                      isEdit: cubit.isEdit,
                      label: 'LastName',
                    ),
                    heightSizedBox(20),
                    GestureDetector(
                      onTap: () => cubit.selectDate(context),
                      child: AbsorbPointer(
                        absorbing: true,
                        child: PersonalInformationTextField(
                          controller: cubit.dateController,
                          isEdit: cubit.isEdit,
                          label: 'BirthDate',
                          isDate: true,
                        ),
                      ),
                    ),
                    heightSizedBox(20),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Gender (optional)',
                          style: Styles.styles14NormalBlack
                              .copyWith(fontWeight: FontWeight.w500),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: 'Male',
                          groupValue: cubit.selectedGender,
                          onChanged: cubit.isEdit
                              ? ((value) {
                                  cubit.changeGender(value: 'Male');
                                })
                              : null,
                          activeColor: kPrimaryGreen,
                          hoverColor: kPrimaryGreen,
                        ),
                        Text(
                          'Male',
                          style: Styles.styles14NormalBlack,
                        ),
                        Radio(
                          value: 'Female',
                          groupValue: cubit.selectedGender,
                          onChanged: cubit.isEdit
                              ? ((value) {
                                  cubit.changeGender(value: 'Female');
                                })
                              : null,
                          activeColor: kPrimaryGreen,
                          hoverColor: kPrimaryGreen,
                        ),
                        Text(
                          'Female',
                          style: Styles.styles14NormalBlack,
                        ),
                      ],
                    ),
                    heightSizedBox(20),
                    !cubit.isEdit
                        ? TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              minimumSize: const Size(double.infinity, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: kPrimaryGreen,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: Text(
                              'Delete Account!',
                              style: Styles.styles18RegularBlack.copyWith(
                                  color: kPrimaryGreen, fontSize: 16.sp),
                            ),
                          )
                        : PetYardTextButton(
                            onPressed: () {
                              cubit.save();
                            },
                            text: 'Save',
                            style: Styles.styles18MediumWhite
                                .copyWith(fontSize: 16.sp),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
