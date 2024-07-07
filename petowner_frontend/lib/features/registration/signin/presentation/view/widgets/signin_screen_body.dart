import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/loading_button.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/registration/signin/data/repo/sign_in_repo.dart';
import 'package:petowner_frontend/features/registration/signin/presentation/view/widgets/first_section.dart';
import 'package:petowner_frontend/features/registration/signin/presentation/view_model/cubit/sign_in_cubit.dart';
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
          padding: EdgeInsets.only(right: 12.0.w, left: 14.0.w, top: 50.0.h),
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
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {
                //       GoRouter.of(context).push(Routes.kForgotPasswordScreen);
                //     },
                //     child: Text(
                //       'Forgot password?',
                //       style: Styles.styles12NormalHalfBlack.copyWith(
                //         color: Colors.blue,
                //       ),
                //     ),
                //   ),
                // ),
                heightSizedBox(20),
                BlocProvider(
                  create: (context) =>
                      SignInCubit(SignInRepo(api: ApiService(dio: Dio()))),
                  child: BlocConsumer<SignInCubit, SignInState>(
                    listener: (context, state) {
                      if (state is SignInFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)));
                      } else if (state is SignInSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login Successful')),
                        );
                        // Navigate to the home screen
                        GoRouter.of(context).push(Routes.kHomeScreen, extra: 0);
                      }
                    },
                    builder: (context, state) {
                      var cubit = BlocProvider.of<SignInCubit>(context);
                      if (state is SignInLoading) {
                        return const LoadingButton(
                          height: 60,
                          radius: 10,
                        );
                      }
                      return PetYardTextButton(
                        onPressed: () {
                          // await _signIn();
                          if (formKey.currentState!.validate()) {
                            // await _signIn();
                            cubit.signIn(
                              password: passwordController.text,
                              email: emailController.text,
                            );
                          }
                          // GoRouter.of(context).push(Routes.kHomeScreen);
                        },
                        text: 'Login!',
                        style: Styles.styles16BoldWhite,
                      );
                    },
                  ),
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
}
