// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/widgets/alternative_signup_option.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/widgets/signup_text_field_column.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/widgets/signup_username_widget.dart';
import 'first_section.dart';
import 'third_section.dart';

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
                const SignUpUserNameWidget(),
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
                const ThirdSection(),
                PetYardTextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                  style: Styles.styles16.copyWith(color: Colors.white),
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
}
