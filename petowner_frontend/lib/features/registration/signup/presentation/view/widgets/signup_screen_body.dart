// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/registration/signup/data/repo/signup_repo.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/view/widgets/alternative_signup_option.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/view/widgets/signup_text_field_column.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/view/widgets/signup_username_widget.dart';
import 'date_of_birth_column.dart';
import 'first_section.dart';
// import 'third_section.dart';

class SignUpScreenBody extends StatefulWidget {
  const SignUpScreenBody({super.key});

  @override
  State<SignUpScreenBody> createState() => _SignUpScreenBodyState();
}

class _SignUpScreenBodyState extends State<SignUpScreenBody> {
  final formKey = GlobalKey<FormState>();
  bool isObsecure = true;
  static TextEditingController phoneNumberController = TextEditingController();
  static TextEditingController emailAddressController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController fNameController = TextEditingController();
  static TextEditingController lNameController = TextEditingController();
  static TextEditingController dateOfBirthController = TextEditingController();

  SignUpRepo signUpRepo = SignUpRepo(api: ApiService(dio: Dio()));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0.w, left: 14.0.w, top: 18.0.h),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FirstSection(),
                SignUpUserNameWidget(
                  fnameController: fNameController,
                  lnameController: lNameController,
                ),
                SizedBox(height: 8.h),
                // const SecondSection(),
                SignUpTextFieldColumn(
                  controller: phoneNumberController,
                  hintText: '+20 | Phone Number',
                  labelText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 8.h),
                SignUpTextFieldColumn(
                  controller: emailAddressController,
                  hintText: 'Email Address',
                  labelText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 8.h),
                SignUpTextFieldColumn(
                  controller: passwordController,
                  sufixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                    icon: !isObsecure
                        ? const Icon(
                            Icons.remove_red_eye_outlined,
                            color: kPrimaryGreen,
                          )
                        : Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black.withOpacity(0.5),
                          ),
                  ),
                  isObsecure: isObsecure,
                  hintText: 'Password',
                  labelText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                SizedBox(height: 8.h),
                DateOfBirthColumn(
                  controller: dateOfBirthController,
                ),
                SizedBox(height: 24.h),
                // const ThirdSection(),
                PetYardTextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      signup();
                    }
                  },
                  style: Styles.styles16BoldWhite,
                ),
                SizedBox(height: 6.h),
                const ALternativeSignupOptionColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signup() async {
    try {
      await signUpRepo.signUp(
        firstName: fNameController.text,
        lastName: lNameController.text,
        email: emailAddressController.text,
        pass: passwordController.text,
        phoneNumber: phoneNumberController.text,
        dateOfBirth: dateOfBirthController.text,
      );
      GoRouter.of(context).push(Routes.kSigninScreen);
      // await apiService.login();
      // Navigate to the next screen upon successful login
    } catch (error) {
      // Handle sign-in error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in failed. Please try again.')),
      );
    }
  }
}
