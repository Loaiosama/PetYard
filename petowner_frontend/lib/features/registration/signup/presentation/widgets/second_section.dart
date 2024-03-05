import 'package:flutter/material.dart';

import 'signup_text_field_column.dart';

class SecondSection extends StatelessWidget {
  const SecondSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SignUpTextFieldColumn(
          hintText: '+20 | Phone Number',
          labelText: 'Phone Number',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 8),
        SignUpTextFieldColumn(
          hintText: 'Email Address',
          labelText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 8),
        SignUpTextFieldColumn(
          hintText: 'Password',
          labelText: 'Password',
          keyboardType: TextInputType.visiblePassword,
          isPassword: true,
        ),
      ],
    );
  }
}
