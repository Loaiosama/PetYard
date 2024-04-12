import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class OnBoardingScreen2 extends StatefulWidget {
  const OnBoardingScreen2({super.key});

  @override
  OnBoardingScreen2State createState() => OnBoardingScreen2State();
}

class OnBoardingScreen2State extends State<OnBoardingScreen2> {
  final PageController pageController = PageController();
  int currentPageIndex = 0;
  List<String> titles = [
    'Trusted Pet Sitting',
    'Happy Pets Guaranteed',
    'Memorable Pet Moments',
  ];

  List<String> body = [
    'Pet Yard Sitters offers reliable pet sitting services for peace of mind when you\'re away.',
    'Pet Yard Groom & Health provides grooming and health care for your pet\'s well-being.',
    'Pet Yard Walks & Onboard ensures every moment with your pet is special, with walks and helpful onboarding.',
  ];

  List pics = [
    'onboarding.svg',
    'onboarding2.svg',
    'onboarding3.svg',
  ];

  List animals = [
    'assets/images/paw.png',
    'assets/images/kitty_onboarding.png',
    'assets/images/dog_onboarding.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kPrimaryGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0.r),
                  bottomRight: Radius.circular(30.0.r),
                ),
              ),
              child: PageView.builder(
                controller: pageController,
                itemCount: 3,
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.20),
                        child: SvgPicture.asset(
                          'assets/svgs/${pics[index]}',
                          height: 300.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      heightSizedBox(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            titles[index],
                            style: Styles.styles18MediumWhite
                                .copyWith(fontSize: 22.sp),
                          ),
                          widthSizedBox(10.0),
                          Transform.rotate(
                            angle: 340 * 3.141592653589793 / 180,
                            child: Image.asset(
                              animals[index],
                              height: 40.0.h,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.0.w, vertical: 16.0.h),
                        child: Text(
                          body[index],
                          textAlign: TextAlign.center,
                          style: Styles.styles16BoldWhite.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 40.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (selectedIndex) => Container(
                              height: 5.h,
                              width: selectedIndex == index ? 20.w : 8.w,
                              margin: EdgeInsets.only(right: 4.0.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: currentPageIndex != 2
                  ? Container(
                      height: 70.h,
                      width: 70.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (currentPageIndex < 2) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          }
                        },
                        icon: Icon(
                          FontAwesomeIcons.arrowRightLong,
                          color: Colors.white.withOpacity(0.94),
                          size: 18.0.sp,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push(Routes.kSignupScreen);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: kPrimaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10.0.r,
                              ),
                            ),
                          ),
                          child: Text(
                            'Sign up!',
                            style: Styles.styles16BoldWhite,
                          ),
                        ),
                        widthSizedBox(8),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push(Routes.kSigninScreen);
                          },
                          style: TextButton.styleFrom(
                            shape: LinearBorder.bottom(
                              size: 0.8,
                              side: const BorderSide(
                                color: kPrimaryGreen,
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: Text(
                            'Sign in!',
                            style: Styles.styles16BoldWhite
                                .copyWith(color: kPrimaryGreen),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
