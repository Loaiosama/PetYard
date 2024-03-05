import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'date_of_birth_text_field.dart';

class DateOfBirthColumn extends StatelessWidget {
  const DateOfBirthColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Date of Birth',
            style: Styles.styles18,
          ),
        ),
        const SizedBox(height: 6),
        const DateOfBirthTexTField(),
      ],
    );
  }
}
