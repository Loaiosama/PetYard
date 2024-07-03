import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

import 'package:petowner_frontend/core/utils/theming/styles.dart';

class Requests extends StatelessWidget {
  const Requests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 245, 240, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: Image.asset(
                width: 300.w,
                height: 300.h,
                "assets/images/pet_type1 (1).png",
              ),
            ),
            SizedBox(
              height: 320.h,
              width: 320.w,
              child: Stack(
                children: [
                  Positioned(
                    left: 12.sp,
                    top: 40,
                    child: Container(
                      width: 300.w,
                      height: 250.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 7),
                            )
                          ]),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15.h,
                              ),
                              Center(
                                child: Text(
                                  "Upload your request in the app and you will receive an offers from providers ",
                                  style: Styles.styles18BoldBlack,
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(Routes.KChooseReq);
                                },
                                child: Container(
                                  width: 180.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: kPrimaryGreen,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Lets get started",
                                      style: Styles.styles14NormalBlack
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: -35.sp,
                      left: 35,
                      child: Image.asset(
                          width: 120.sp,
                          height: 120.sp,
                          "assets/images/ota_nayma.png")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
