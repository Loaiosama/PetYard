import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/registration/signin/data/repo/sign_in_repo.dart';
import 'package:petowner_frontend/features/registration/signin/presentation/view/widgets/first_section.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/view/widgets/alternative_signup_option.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/view/widgets/signup_text_field_column.dart';

class SignInScreenBody extends StatefulWidget {
  const SignInScreenBody({super.key});

  @override
  State<SignInScreenBody> createState() => _SignInScreenBodyState();
}

class _SignInScreenBodyState extends State<SignInScreenBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObsecure = true;
  final formKey = GlobalKey<FormState>();
  SignInRepo signInRepo = SignInRepo(api: ApiService(dio: Dio()));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 12.0.w, left: 14.0.w, top: 20.0.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FirstSection(),
                SignUpTextFieldColumn(
                  hintText: 'Email Address',
                  labelText: 'Email Address',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      GoRouter.of(context).push(Routes.kForgotPasswordScreen);
                    },
                    child: Text(
                      'Forgot password?',
                      style: Styles.styles12NormalHalfBlack.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                PetYardTextButton(
                  onPressed: () async {
                    // await _signIn();
                    if (formKey.currentState!.validate()) {
                      await _signIn();
                    }
                  },
                  text: 'Login!',
                  style: Styles.styles16BoldBlack.copyWith(color: Colors.white),
                ),
                SizedBox(height: 16.h),
                const ALternativeSignupOptionColumn(
                  isSignUp: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    try {
      await signInRepo.login(
        password: passwordController.text,
        email: emailController.text,
      );
      GoRouter.of(context).push(Routes.kHomeScreen);
      // await apiService.login();
      // Navigate to the next screen upon successful login
    } catch (error) {
      // Handle sign-in error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Sign-in failed(Incorrect email or password). Please try again. ===$error')),
      );
    }
  }
}
