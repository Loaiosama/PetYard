import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class ProviderScreenSearchTextField extends StatelessWidget {
  const ProviderScreenSearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0.h, left: 20.0.w),
      child: Row(
        children: [
          SizedBox(
            height: 50.h,
            width: MediaQuery.of(context).size.width * 0.80,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                fillColor: Colors.grey.withOpacity(0.2),
                hintStyle:
                    Styles.styles12NormalHalfBlack.copyWith(fontSize: 14.sp),
                filled: true,
                prefixIcon: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 16.sp,
                  color: Colors.black.withOpacity(0.5),
                ),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide:
                        BorderSide(color: Colors.black.withOpacity(0.5))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide:
                        BorderSide(color: Colors.black.withOpacity(0.5))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide:
                        BorderSide(color: Colors.black.withOpacity(0.5))),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.filter),
          ),
        ],
      ),
    );
  }
}
