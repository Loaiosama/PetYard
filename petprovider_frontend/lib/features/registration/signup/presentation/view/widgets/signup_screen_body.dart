// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/widgets/signup_text_field_column.dart';
import '../../../../../../core/utils/networking/api_service.dart';
import '../../../../../../core/utils/routing/routes.dart';
import '../../../../../../core/utils/theming/colors.dart';
import '../../../../../../core/utils/theming/styles.dart';
import '../../../../../../core/widgets/petyard_text_button.dart';
import '../../../data/repo/signup_repo.dart';
import 'alternative_signup_option.dart';
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
  static TextEditingController emailAddressController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController userNameController = TextEditingController();

  SignUpRepo signUpRepo = SignUpRepo(api: ApiService(dio: Dio()));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.0.w, left: 18.0.w, top: 50.0.h),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FirstSection(
                  title: 'Create Account',
                  subTitle:
                      'Sign up now and start exploring all that our app has to offer. We\'re excited to welcome you to our community!',
                ),
                SignUpTextFieldColumn(
                  hintText: 'User Name',
                  labelText: 'User Name',
                  controller: userNameController,
                ),
                SizedBox(height: 8.h),
                // const SecondSection(),

                // SizedBox(height: 8.h),
                SignUpTextFieldColumn(
                  controller: emailAddressController,
                  hintText: 'Email Address',
                  labelText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  isEmail: true,
                ),
                SizedBox(height: 8.h),
                SignUpTextFieldColumn(
                  controller: passwordController,
                  suffixIcon: IconButton(
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

                SizedBox(height: 24.h),
                PetYardTextButton(
                  onPressed: () {
                    // print('hello');

                    if (formKey.currentState!.validate()) {
                      GoRouter.of(context)
                          .push(Routes.kFillInformation, extra: {
                        "userName": userNameController.text,
                        "email": emailAddressController.text,
                        "password": passwordController.text,
                      });
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
}
