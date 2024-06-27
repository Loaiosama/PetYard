import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
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
      create: (context) => PersonalInformationCubit()..getOwnerInfo(),
      child: BlocBuilder<PersonalInformationCubit, PersonalInformationState>(
        builder: (context, state) {
          PersonalInformationCubit cubit = BlocProvider.of(context);

          if (state is PersonalInformationInitial) {
            return const Center(child: CircularProgressIndicator());
          }
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
                    PersonalInformationTextField(
                      controller: cubit.phoneNumberController,
                      isEdit: cubit.isEdit,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                    ),
                    heightSizedBox(20),
                    GestureDetector(
                      onTap: () =>
                          cubit.isEdit ? cubit.selectDate(context) : null,
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
                        : BlocConsumer<PersonalInformationCubit,
                            PersonalInformationState>(
                            listener: (context, state) {
                              if (state is UpdateOwnerInformationFailure) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Something went wrong!',
                                          style: Styles.styles14NormalBlack
                                              .copyWith(color: Colors.red),
                                        ),
                                        content: Text(
                                          'Failed to update account info.',
                                          style: Styles
                                              .styles12RegularOpacityBlack,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              GoRouter.of(context).push(
                                                  Routes.kHomeScreen,
                                                  extra: 4);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    });
                              } else if (state
                                  is UpdateOwnerInformationSuccess) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Done!',
                                          style: Styles.styles14NormalBlack
                                              .copyWith(color: Colors.green),
                                        ),
                                        content: Text(
                                          'Info Updated Successfully.',
                                          style: Styles
                                              .styles12RegularOpacityBlack,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              GoRouter.of(context).push(
                                                  Routes.kHomeScreen,
                                                  extra: 4);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                            builder: (context, state) {
                              if (state is UpdateOwnerInformationLoading) {
                                return TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    backgroundColor: kPrimaryGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    minimumSize: Size(double.infinity, 60.h),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      height: 20.sp,
                                      width: 20.sp,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return PetYardTextButton(
                                onPressed: () {
                                  // cubit.save();
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                    DateFormat('dd-MM-yyyy')
                                        .parse(cubit.dateController.text),
                                  );

                                  cubit.updateOwnerInformation(
                                    firstName: cubit.fNameController.text,
                                    lastName: cubit.lNameController.text,
                                    pass:
                                        '123', // Assuming pass is a required field
                                    email: cubit.emailController.text,
                                    phoneNumber:
                                        cubit.phoneNumberController.text,
                                    dateOfBirth: DateTime.parse(formattedDate),
                                  );
                                },
                                text: 'Save',
                                style: Styles.styles18MediumWhite
                                    .copyWith(fontSize: 16.sp),
                              );
                            },
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
