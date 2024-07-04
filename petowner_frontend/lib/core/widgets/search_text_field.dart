import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class SearchTextField extends StatelessWidget {
  final void Function(String) onChanged;

  const SearchTextField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0.h, left: 20.0.w),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50.h,
              child: TextFormField(
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: 'Search',
                  fillColor: Colors.grey.withOpacity(0.2),
                  hintStyle:
                      Styles.styles12NormalHalfBlack.copyWith(fontSize: 14.sp),
                  filled: true,
                  prefixIcon: Icon(
                    FontAwesomeIcons.search,
                    size: 16.sp,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
