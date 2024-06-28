import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/networking/api_service.dart';
import '../../../../../../core/utils/routing/routes.dart';
import '../../../../../../core/utils/theming/colors.dart';
import '../../../../../../core/utils/theming/styles.dart';
import '../../../../../../core/widgets/loading_button.dart';
import '../../../../../../core/widgets/petyard_text_button.dart';
import '../../../../signup/presentation/view/widgets/alternative_signup_option.dart';
import '../../../../signup/presentation/view/widgets/first_section.dart';
import '../../../../signup/presentation/view/widgets/signup_text_field_column.dart';
import '../../../data/repo/sign_in_repo.dart';
import '../../view_model/signin_cubit/sign_in_cubit.dart';

class SignInScreenBody extends StatefulWidget {
  const SignInScreenBody({super.key});

  @override
  State<SignInScreenBody> createState() => _SignInScreenBodyState();
}

class _SignInScreenBodyState extends State<SignInScreenBody> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObsecure = true;
  final formKey = GlobalKey<FormState>();
  SignInRepo signInRepo = SignInRepo(api: ApiService(dio: Dio()));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 16.0.w, left: 18.0.w, top: 50.0.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FirstSection(
                  title: 'Welcome Back',
                  subTitle:
                      'We\'re excited to have you back, can\'t wait to see what you\'ve been up to since you last logged in.',
                ),
                SignUpTextFieldColumn(
                  hintText: 'Username',
                  controller: userNameController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
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
                        // print(state.status);
                        if (state.status == 'Login Successful') {
                          GoRouter.of(context)
                              .push(Routes.kHomeScreen, extra: 0);
                        } else if (state.status == 'Choose Services') {
                          GoRouter.of(context).push(Routes.kChooseService);
                        }
                        // print('success');
                        // Navigate to the home screen
                        // GoRouter.of(context).push(Routes.kHomeScreen, extra: 0);
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
                              userName: userNameController.text,
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
