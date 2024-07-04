import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';

class PersonalInformationTextField extends StatelessWidget {
  const PersonalInformationTextField({
    super.key,
    required this.controller,
    required this.isEdit,
    required this.label,
    this.isEmail = false,
    this.isDate = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final bool isEdit;
  final String label;
  final bool? isEmail;
  final bool? isDate;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: !isEmail! ? (isEdit ? true : false) : false,
      readOnly: isDate! ? true : false,
      // enabled: isEdit ? true : false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        enabledBorder: customEnabledOutlinedBorder,
        focusedBorder: customFocusedOutlinedBorder,
        border: customEnabledOutlinedBorder,
        errorBorder: customErrorOutlinedBorder,
        labelText: label,
        labelStyle: !isEmail!
            ? (isEdit ? const TextStyle(color: kPrimaryGreen) : null)
            : null,
        suffix: isDate!
            ? isEdit
                ? const Icon(
                    Icons.calendar_today_outlined,
                    color: kPrimaryGreen,
                  )
                : Icon(
                    Icons.calendar_today_outlined,
                    color: iconColor,
                  )
            : null,
      ),
    );
  }
}
