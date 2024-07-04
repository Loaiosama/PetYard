import 'package:flutter/material.dart';
import 'signup_text_field_column.dart';

class SignUpUserNameWidget extends StatelessWidget {
  const SignUpUserNameWidget({
    super.key,
    required this.fnameController,
    required this.lnameController,
  });
  final TextEditingController fnameController;
  final TextEditingController lnameController;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SignUpTextFieldColumn(
          controller: fnameController,
          hintText: 'First Name',
          labelText: 'First Name',
          keyboardType: TextInputType.name,
          width: MediaQuery.of(context).size.width * 0.45,
          // focusNode: fnFocusNode,
        ),
        const Spacer(),
        SignUpTextFieldColumn(
          controller: lnameController,
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
