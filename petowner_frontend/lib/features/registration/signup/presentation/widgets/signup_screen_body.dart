// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'first_section.dart';
import 'second_section.dart';
import 'third_section.dart';

class SignUpScreenBody extends StatelessWidget {
  const SignUpScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0.w, left: 14.0.w, top: 18.0.h),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FirstSection(),
              SizedBox(height: 8.h),
              const SecondSection(),
              SizedBox(height: 8.h),
              const ThirdSection(),
            ],
          ),
        ),
      ),
    );
  }
}
