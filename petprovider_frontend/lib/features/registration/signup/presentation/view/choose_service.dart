import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/widgets/first_section.dart';

import '../../../../../core/utils/theming/styles.dart';
import '../../../../../core/widgets/petyard_text_button.dart';

class ChooseService extends StatefulWidget {
  const ChooseService({super.key});

  @override
  ChooseServiceState createState() => ChooseServiceState();
}

class ChooseServiceState extends State<ChooseService> {

  // List to manage selected services
  List<bool> selectedServices = [false, false, false, false];

  // List of services with icon and name
  final List<Map<String, dynamic>> services = [
    {'icon': 'choose_boarding.svg', 'name': 'Pet Boarding'},
    {'icon': 'choose_walking.svg', 'name': 'Pet Walking'},
    {'icon': 'choose_grooming.svg', 'name': 'Pet Grooming'},
    {'icon': 'choose_sitting.svg', 'name': 'Pet Sitting'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            right: 16.0.w,
            left: 18.0.w,
            top: 50.0.h,
            bottom: 70.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FirstSection(
                title: 'Almost There!',
                subTitle:
                'Choose one or more services you want to provide. And don\'t worry, you can always add more services later.',
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedServices[index] = !selectedServices[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedServices[index] ? kPrimaryGreen : Colors.grey.shade200,
                          border: Border.all(
                            color: selectedServices[index] ? kPrimaryGreen : kSecondaryColor,
                            width: selectedServices[index] ? 2.0.w : 1.0.w,
                          ),
                          borderRadius: BorderRadius.circular(15.0.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/svgs/${services[index]['icon']}',height: 90.h,),
                            SizedBox(height: 10.h),
                            Text(
                              services[index]['name'],
                              style: TextStyle(
                                color: selectedServices[index] ? kSecondaryColor : kPrimaryGreen,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              PetYardTextButton(
                onPressed: () {
                },
                text: 'Continue',
                style: Styles.styles16BoldWhite,
              )
            ],
          ),
        ),
      ),
    );
  }
}
