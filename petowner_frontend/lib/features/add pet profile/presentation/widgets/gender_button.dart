import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class GenderButton extends StatefulWidget {
  final String text;
  final BorderRadius? borderRadius;
  final bool isSelected;
  final Function(bool) onSelect;

  const GenderButton({
    super.key,
    required this.text,
    required this.borderRadius,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GenderButtonState createState() => _GenderButtonState();
}

class _GenderButtonState extends State<GenderButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Material(
        elevation: 0,
        child: TextButton(
          onPressed: () {
            widget.onSelect(!widget.isSelected);
          },
          style: TextButton.styleFrom(
            backgroundColor:
                widget.isSelected ? kPrimaryGreen : Colors.grey[400],
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            ),
          ),
          child: Text(
            widget.text,
            style: Styles.styles14NormalBlack.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
