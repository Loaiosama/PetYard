// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'first_section.dart';
import 'second_section.dart';
import 'third_section.dart';

class SignUpScreenBody extends StatelessWidget {
  const SignUpScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:
          EdgeInsets.only(right: 12.0, left: 20.0, top: 20.0, bottom: 20.0),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FirstSection(),
              SizedBox(height: 8),
              SecondSection(),
              SizedBox(height: 8),
              ThirdSection(),
            ],
          ),
        ),
      ),
    );
  }
}
