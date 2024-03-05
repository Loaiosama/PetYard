// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

InputBorder customEnabledOutlinedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0.r),
  borderSide: BorderSide(
    color: Colors.black.withOpacity(0.2),
    width: 2.0,
  ),
);

InputBorder customFocusedOutlinedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0.r),
  borderSide: const BorderSide(
    color: Color.fromRGBO(0, 170, 91, 1),
    width: 2.0,
  ),
);

InputBorder customBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0.r),
);

class CustomRegistrationTextField extends StatefulWidget {
  const CustomRegistrationTextField({
    super.key,
    this.hintText = 'HINT',
    this.keyboardType,
    required this.width,
    this.height = 60,
    this.isPassword = false,
    // required this.focusNode,
  });

  final String hintText;
  final TextInputType? keyboardType;
  final double width;
  final double height;
  final bool? isPassword;
  // final FocusNode focusNode;
  @override
  State<CustomRegistrationTextField> createState() =>
      _CustomRegistrationTextFieldState();
}

class _CustomRegistrationTextFieldState
    extends State<CustomRegistrationTextField> {
  bool textFieldColor = false;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // focusNode: widget.focusNode,
      onTapOutside: (event) {
        setState(() {
          textFieldColor = false;
          FocusManager.instance.primaryFocus?.unfocus();
        });
      },
      onTap: () {
        setState(() {
          textFieldColor = !textFieldColor;
        });
      },
      onFieldSubmitted: (value) {
        setState(() {
          textFieldColor = false;
        });
      },
      obscureText: isVisible ? true : false,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        constraints: BoxConstraints.tightForFinite(
          width: widget.width,
        ),
        suffixIcon: (widget.isPassword!)
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: !isVisible
                    ? const Icon(
                        Icons.remove_red_eye_outlined,
                        color: kPrimaryGreen,
                      )
                    : Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.black.withOpacity(0.5),
                      ),
              )
            : null,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 14.sp,
        ),
        border: customBorder,
        enabledBorder: customEnabledOutlinedBorder,
        focusedBorder: customFocusedOutlinedBorder,
      ),
    );
  }
}
