import 'package:flutter/material.dart';
import 'date_of_birth_text_field.dart';

class DateOfBirthColumn extends StatelessWidget {
  const DateOfBirthColumn({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DateOfBirthTexTField(
          controller: controller,
        ),
      ],
    );
  }
}
