import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';

import 'package:petowner_frontend/core/utils/theming/styles.dart';

class ChooseRequest extends StatelessWidget {
  const ChooseRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 245, 240, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 55.h,
            ),
            Center(
              child: Text(
                "Choose the service",
                style: Styles.styles18BoldBlack,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 200.h,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 300.w,
                        height: 132.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color.fromARGB(255, 221, 168, 230),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -12,
                              left: -25.w,
                              child: Transform.rotate(
                                angle: 2.3, // Adjust the angle as needed
                                child: Icon(Icons.pets,
                                    size: 120.sp, // Adjust the size as needed
                                    color: Colors.black.withOpacity(
                                        0.1) // Adjust the color as needed
                                    ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Pet Sitting",
                                        style: Styles.styles16BoldBlack
                                            .copyWith(fontSize: 22),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        width: 100.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              context.pushNamed(
                                                  Routes.KPetSitting);
                                            },
                                            child: Text(
                                              "Make Request",
                                              style:
                                                  Styles.styles16w600.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 200,
                      top: -8,
                      child: Image.asset(
                        width: 150.w,
                        height: 150.h,
                        "assets/images/new_sitting.png",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 200.h,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 300.w,
                        height: 132.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color.fromARGB(255, 107, 183, 245),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -12,
                              right: -25.w,
                              child: Transform.rotate(
                                angle: -2.3, // Adjust the angle as needed
                                child: Icon(Icons.pets,
                                    size: 125.sp, // Adjust the size as needed
                                    color: Colors.black.withOpacity(
                                        0.1) // Adjust the color as needed
                                    ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 20.w,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Pet Boarding",
                                        style: Styles.styles16BoldBlack
                                            .copyWith(fontSize: 22),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        width: 100.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Make Request",
                                            style: Styles.styles16w600.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 200,
                      top: -5,
                      child: Image.asset(
                        width: 165.w,
                        height: 165.h,
                        "assets/images/girl.png",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 200.h,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 300.w,
                        height: 132.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color.fromARGB(255, 255, 242, 127),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -12,
                              left: -25.w,
                              child: Transform.rotate(
                                angle: 2.3, // Adjust the angle as needed
                                child: Icon(Icons.pets,
                                    size: 120.sp, // Adjust the size as needed
                                    color: Colors.black.withOpacity(
                                        0.1) // Adjust the color as needed
                                    ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Pet Groming",
                                        style: Styles.styles16BoldBlack
                                            .copyWith(fontSize: 22),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        width: 100.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Make Request",
                                            style: Styles.styles16w600.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 200,
                      top: -3,
                      child: Image.asset(
                        width: 150.w,
                        height: 150.h,
                        "assets/images/doctor.png",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
