// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

InputBorder customEnabledOutlinedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: BorderSide(
    color: Colors.black.withOpacity(0.2),
    width: 2.0,
  ),
);

InputBorder customFocusedOutlinedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(
    color: Color.fromRGBO(0, 170, 91, 1),
    width: 2.0,
  ),
);

InputBorder customBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
);

class CustomRegistrationTextField extends StatefulWidget {
  const CustomRegistrationTextField({
    super.key,
    this.hintText = 'HINT',
    this.keyboardType,
    required this.width,
    // required this.focusNode,
  });

  final String hintText;
  final TextInputType? keyboardType;
  final double width;
  // final FocusNode focusNode;
  @override
  State<CustomRegistrationTextField> createState() =>
      _CustomRegistrationTextFieldState();
}

class _CustomRegistrationTextFieldState
    extends State<CustomRegistrationTextField> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // focusNode: widget.focusNode,
      onTapOutside: (event) {
        setState(() {
          flag = false;
          FocusManager.instance.primaryFocus?.unfocus();
        });
      },
      onTap: () {
        setState(() {
          flag = !flag;
        });
      },
      onFieldSubmitted: (value) {
        setState(() {
          flag = false;
        });
      },
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        constraints: BoxConstraints.tightForFinite(width: widget.width),
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
          // color: widget.focusNode.hasFocus
          //     ? const Color.fromRGBO(0, 170, 91, 1)
          //     : Colors.black.withOpacity(0.5),
          fontSize: 18,
        ),
        border: customBorder,
        enabledBorder: customEnabledOutlinedBorder,
        focusedBorder: customFocusedOutlinedBorder,
      ),
    );
  }
}
