import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/date_picker.dart';
import 'package:petowner_frontend/features/pet%20sitting/presentation/view/widgets/hour_data_picker.dart';

class PetSitting extends StatefulWidget {
  const PetSitting({Key? key}) : super(key: key);

  @override
  _PetSittingState createState() => _PetSittingState();
}

class _PetSittingState extends State<PetSitting> {
  int offerPrice = 0;
  final TextEditingController priceController = TextEditingController();

  void incrementPrice() {
    setState(() {
      offerPrice++;
      priceController.text = offerPrice.toString();
    });
  }

  void decrementPrice() {
    if (offerPrice > 0) {
      setState(() {
        offerPrice--;
        priceController.text = offerPrice.toString();
      });
    }
  }

  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35.h),
            Center(
              child: Container(
                width: 300.w,
                height: 164.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Color.fromRGBO(252, 189, 89, 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      )
                    ]),
                child: Stack(
                  children: [
                    Positioned(
                      top: 32,
                      left: 200,
                      child: Image.asset(
                        "assets/images/golden_cat_2.png",
                        width: 140.w,
                        height: 140.h,
                      ),
                    ),
                    Positioned(
                        left: 170.w,
                        child: Transform.rotate(
                          angle: -0.8,
                          child: FaIcon(
                            FontAwesomeIcons.heart,
                            size: 80.sp,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        )),
                    Positioned(
                        top: -18.h,
                        left: -26.w,
                        child: Transform.rotate(
                          angle: 2.3,
                          child: FaIcon(
                            FontAwesomeIcons.paw,
                            size: 120.sp,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 25),
                      child: SizedBox(
                        width: 180,
                        child: Text(
                          "Find a pet sitter that will sit with your pet for a couple of hours",
                          style: Styles.styles16BoldWhite.copyWith(
                              fontSize: 20,
                              color: Color.fromRGBO(49, 57, 68, 1)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: DateHourPicker(
                labelText: "Start time",
                onDateSelected: (date) {},
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: DateHourPicker(
                labelText: "End time",
                onDateSelected: (date) {},
              ),
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Offer Your Price",
                    style: Styles.styles16BoldBlack.copyWith(fontSize: 22),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: decrementPrice,
                        child: Image.asset(
                          "assets/images/minus_G.png",
                          width: 40.w,
                          height: 40.h,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Container(
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: TextFormField(
                          controller: priceController,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              offerPrice = int.tryParse(value) ?? 0;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: incrementPrice,
                        child: Image.asset(
                          "assets/images/plus_G.png",
                          width: 40.w,
                          height: 40.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
