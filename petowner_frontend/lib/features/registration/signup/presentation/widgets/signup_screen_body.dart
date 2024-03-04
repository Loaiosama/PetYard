// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petowner_frontend/core/constants/constants.dart';

import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';

class SignUpScreenBody extends StatelessWidget {
  const SignUpScreenBody({super.key});

  // FocusNode fnFocusNode = FocusNode();
  // FocusNode lnFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          right: 12.0, left: 20.0, top: 20.0, bottom: 20.0),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let\'s get started!',
                style: Styles.styles24.copyWith(color: kPrimaryGreen),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  'Create an account now to use all of PetYard services.',
                  style: Styles.styles14,
                ),
              ),
              const SizedBox(height: 16),
              const SignUpUserNameWidget(),
              const SizedBox(height: 8),
              const SignUpTextFieldColumn(
                hintText: '+20 | Phone Number',
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              const SignUpTextFieldColumn(
                hintText: 'Email Address',
                labelText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              const SignUpTextFieldColumn(
                  hintText: 'hintText', labelText: 'labelText'),
              const SizedBox(height: 8),
              const SignUpTextFieldColumn(
                  hintText: 'hintText', labelText: 'labelText'),
              const SizedBox(height: 16),
              PetYardTextButton(
                style: Styles.styles18.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: const Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Text(
                      'Or',
                      style: Styles.styles16,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: const Divider(),
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Sign up with',
                      style: Styles.styles16,
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.black.withOpacity(0.3), width: 1),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(
                              '${Constants.assetsImage}/google_logo.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpUserNameWidget extends StatelessWidget {
  const SignUpUserNameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SignUpTextFieldColumn(
          hintText: 'First Name',
          labelText: 'First Name',
          keyboardType: TextInputType.name,
          width: MediaQuery.of(context).size.width * 0.45,
          // focusNode: fnFocusNode,
        ),
        const Spacer(),
        SignUpTextFieldColumn(
          hintText: 'Last Name',
          labelText: 'Last Name',
          keyboardType: TextInputType.name,
          width: MediaQuery.of(context).size.width * 0.45,
          // focusNode: lnFocusNode,
        ),
      ],
    );
  }
}

class SignUpTextFieldColumn extends StatelessWidget {
  const SignUpTextFieldColumn({
    super.key,
    required this.hintText,
    required this.labelText,
    this.width = double.infinity,
    this.keyboardType,
    // required this.focusNode,
  });

  final String hintText;
  final String labelText;
  final double width;
  final TextInputType? keyboardType;

  // final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            labelText,
            style: Styles.styles18,
          ),
        ),
        const SizedBox(height: 6),
        CustomRegistrationTextField(
          hintText: hintText,
          width: width,
          keyboardType: keyboardType,
          // focusNode: focusNode,
        ),
      ],
    );
  }
}
