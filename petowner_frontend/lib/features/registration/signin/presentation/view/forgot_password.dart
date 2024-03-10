import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            right: 12.0.w, left: 14.0.w, top: 20.0.h, bottom: 30.h),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot Password',
                style: Styles.styles22BoldGreen,
              ),
              heightSizedBox(8),
              Text(
                'At PetYard, We take the security of your information seriously',
                style: Styles.styles12NormalHalfBlack,
              ),
              heightSizedBox(14),
              CustomRegistrationTextField(
                width: double.infinity,
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field can\'t be empty';
                  }
                  return null;
                },
                hintText: 'Email or Phone Number',
              ),
              const Spacer(),
              PetYardTextButton(
                onPressed: () {},
                text: 'Reset Password',
                style: Styles.styles14NormalBlack.copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
