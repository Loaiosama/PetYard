import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class PetWeightItem extends StatefulWidget {
  final String text;
  final bool isSelected;
  final Function(bool) onSelect;

  const PetWeightItem({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<PetWeightItem> createState() => _PetWeightItemState();
}

class _PetWeightItemState extends State<PetWeightItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(!widget.isSelected);
      },
      child: Container(
        width: 80.w,
        height: 35.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.isSelected ? kPrimaryGreen : Colors.white,
          border: Border.all(
            color: kPrimaryGreen,
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: Styles.styles12NormalHalfBlack.copyWith(color : Colors.black),
          ),
        ),
      ),
    );
  }
}