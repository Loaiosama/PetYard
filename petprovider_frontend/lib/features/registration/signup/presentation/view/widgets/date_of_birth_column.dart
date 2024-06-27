import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/utils/theming/styles.dart';
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
