import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/pet_carer_card.dart';
import 'package:stroke_text/stroke_text.dart';

class PetInformationScreen extends StatelessWidget {
  const PetInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PetInfromationScreenBody(),
    );
  }
}

class PetInfromationScreenBody extends StatelessWidget {
  const PetInfromationScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.39,
          width: double.infinity,
          child: Image.asset(
            'assets/images/pet_information.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 6.0.w, right: 6.0.w, top: 40.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(
                    //     Icons.more_vert_sharp,
                    //     color: Colors.white,
                    //     size: 30,
                    //   ),
                    // ),
                  ],
                ),
              ),
              heightSizedBox(200),
              Expanded(
                child: Material(
                  elevation: 2.0,
                  color: Colors.white,
                  shadowColor: kPrimaryGreen,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.3),
                      width: 1.0,
                      strokeAlign: 3,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20.0.h, right: 20.0.w, left: 20.0.w),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Maxi',
                                    style: Styles.styles18BoldBlack,
                                  ),
                                  Text(
                                    'German Shepherd',
                                    style: Styles.styles12NormalHalfBlack,
                                  ),
                                  heightSizedBox(2),
                                  const RatingRowWidget()
                                ],
                              ),
                              Material(
                                elevation: 1.0,
                                shape: const CircleBorder(),
                                child: Tooltip(
                                  message: 'Delete Pet Profile',
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.redAccent,
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          heightSizedBox(16),
                          const AgeSexWeightRow(),
                          heightSizedBox(16),
                          Text(
                            'About Maxi',
                            style: Styles.styles14w600,
                          ),
                          heightSizedBox(8),
                          Text(
                            'A lovely German Shepeard A lovely German Shepeard A lovely German Shepeard A lovely German Shepeard A lovely German Shepeard A lovely German Shepeard A lovely German Shepeard A lovely German Shepeard A lovely German Shepeard A lovely German Shepeard A lovely German Shepeard.',
                            style: Styles.styles12NormalHalfBlack,
                          ),
                          heightSizedBox(16),
                          Text(
                            'Adoption Date',
                            style: Styles.styles14w600,
                          ),
                          heightSizedBox(8),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range_outlined,
                                color: Colors.black.withOpacity(0.4),
                                size: 18.sp,
                              ),
                              widthSizedBox(8),
                              Text(
                                '26-3-2018',
                                style: Styles.styles12NormalHalfBlack,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AgeSexWeightRow extends StatelessWidget {
  const AgeSexWeightRow({super.key});
  static List colors = [
    const Color.fromRGBO(184, 81, 98, 1),
    const Color.fromRGBO(85, 164, 239, 1),
    const Color.fromRGBO(240, 188, 68, 1),
  ];

  static List title = [
    'Gender',
    'Age',
    'Weight',
  ];
  static List values = [
    'Male',
    '3 years',
    '3 KG',
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(
          3,
          (index) => Container(
            height: 140.h,
            width: 100.w,
            margin: index < 2 ? EdgeInsets.only(right: 10.w) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(10.0.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // angle: 340 * 3.141592653589793 / 180,
                Padding(
                  padding: EdgeInsets.only(right: 4.0.w, bottom: 2.0.h),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Transform.rotate(
                      angle: 340 * 3.141592653589793 / 180,
                      child: Icon(
                        FontAwesomeIcons.paw,
                        color: Colors.white.withOpacity(0.2),
                        size: 46.0.sp,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title[index],
                      style: Styles.styles16w600.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    StrokeText(
                      text: values[index],
                      textStyle: Styles.styles18BoldBlack.copyWith(
                        color: Colors.white,
                      ),
                      strokeWidth: 0.7,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
