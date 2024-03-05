import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';

import 'alternative_signup_option.dart';
import 'signup_text_field_column.dart';

class ThirdSection extends StatelessWidget {
  const ThirdSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SignUpTextFieldColumn(
          hintText: '26 januarary 2003',
          labelText: 'Date of birth',
          isPassword: false,
        ),
        const SizedBox(height: 16),
        PetYardTextButton(
          style: Styles.styles18.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 4),
        const ALternativeSignupOptionColumn(),
      ],
    );
  }
}
