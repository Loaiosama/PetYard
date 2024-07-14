import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/loading_button.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/registration/signup/data/repo/signup_repo.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/view%20model/cubit/sign_up_cubit.dart';

class ValidationCodeScreen extends StatefulWidget {
  const ValidationCodeScreen({super.key, required this.email});
  final String email;

  @override
  ValidationCodeScreenState createState() => ValidationCodeScreenState();
}

class ValidationCodeScreenState extends State<ValidationCodeScreen> {
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18.sp,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          right: 16.0.w,
          left: 18.0.w,
          top: 20.0.h,
          bottom: 20.0.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Validation Code',
              style: Styles.styles22BoldGreen,
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                'We have sent a validation code to your email.',
                style: Styles.styles12NormalHalfBlack,
              ),
            ),
            SizedBox(height: 14.h),
            heightSizedBox(10),
            OtpForm(
              onOtpEntered: (enteredOtp) {
                setState(() {
                  otp = enteredOtp;
                });
              },
            ),
            const Spacer(),
            BlocProvider(
              create: (context) =>
                  SignUpCubit(SignUpRepo(api: ApiService(dio: Dio()))),
              child: BlocConsumer<SignUpCubit, SignUpState>(
                listener: (context, state) {
                  if (state is ValidationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  } else if (state is ValidationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign Up Successful!')),
                    );
                    // Navigate to the home screen
                    GoRouter.of(context).push(Routes.kSigninScreen);
                  }
                },
                builder: (context, state) {
                  var cubit = BlocProvider.of<SignUpCubit>(context);
                  if (state is ValidationLoading) {
                    return const LoadingButton(
                      height: 60,
                      radius: 10,
                    );
                  }
                  return PetYardTextButton(
                    height: 50.h,
                    onPressed: () {
                      cubit.validateCode(
                          email: widget.email, validationCode: otp);
                    },
                    text: 'Submit',
                    style: Styles.styles16BoldWhite,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OtpForm extends StatefulWidget {
  final Function(String) onOtpEntered;
  const OtpForm({super.key, required this.onOtpEntered});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  late List<TextEditingController> _controllers;
  late String otp;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    otp = '';
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1) {
      FocusScope.of(context).nextFocus();
      if (index == _controllers.length - 1) {
        otp = _controllers.map((controller) => controller.text).join();
        widget.onOtpEntered(otp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          4,
          (index) => SizedBox(
            height: 68.h,
            width: 60.w,
            child: TextFormField(
              controller: _controllers[index],
              keyboardType: TextInputType.number,
              onChanged: (value) => _onChanged(index, value),
              decoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0.r),
                ),
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
