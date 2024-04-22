import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/pet_carer_card.dart';

class ProviderProfileBody extends StatelessWidget {
  const ProviderProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, top: 16.0.h),
      child: Column(
        children: [
          const ProviderProfileCard(),
          heightSizedBox(24),
          Padding(
            padding: EdgeInsets.only(right: 12.0.w),
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    // controller: tabController,
                    labelStyle:
                        Styles.styles14w600.copyWith(color: kPrimaryGreen),
                    unselectedLabelStyle: Styles.styles12RegularOpacityBlack
                        .copyWith(fontSize: 14.sp),
                    indicatorColor: kPrimaryGreen,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.only(bottom: 4.0.h),
                    physics: const BouncingScrollPhysics(),
                    tabs: const [
                      Text('About'),
                      Text('Location'),
                      Text('Reviews'),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.59,
                    child: const TabBarView(
                      // controller: tabController,
                      children: [
                        AboutTabColumn(),
                        LocationTabColumn(),
                        ReviewsTabColumn(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.0.w, top: 20.0.h),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: PetYardTextButton(
                      onPressed: () {
                        GoRouter.of(context).push(Routes.kbookAppointment);
                      },
                      text: 'Make An Appointment',
                      style: Styles.styles14w600.copyWith(
                        color: Colors.white,
                      ),
                      // color: kBlue,
                      height: 54.0.h,
                      // width: MediaQuery.of(context).size.width * 0.73,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 54.h,
                    // width: MediaQuery.of(context).size.width * 0.14,
                    decoration: BoxDecoration(
                      color: kPrimaryGreen,
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Tooltip(
                        message: 'Send a message to Olivia.',
                        child: Icon(
                          FluentIcons.chat_20_regular,
                          color: Colors.white,
                          size: 28.0.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewListItem extends StatelessWidget {
  const ReviewListItem({super.key});
  final int review = 4;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.0.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/1.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              widthSizedBox(6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jane Cooper',
                    style: Styles.styles14w600,
                  ),
                  heightSizedBox(4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < review ? Colors.yellow : Colors.grey,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  heightSizedBox(4),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 60.0.w),
            child: Text(
              'As someone who lives in a remote area with limited access to healthcare, this telemedicine app has been a game changer for me. I can easily schedule virtual appointments with doctors and get the care I need without having to travel long distances.',
              style: Styles.styles12NormalHalfBlack,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewsTabColumn extends StatelessWidget {
  const ReviewsTabColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSizedBox(12),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return const ReviewListItem();
            },
          ),
        ),
      ],
    );
  }
}

class LocationTabColumn extends StatelessWidget {
  const LocationTabColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSizedBox(12),
        Row(
          children: [
            Icon(
              FontAwesomeIcons.locationDot,
              color: const Color.fromRGBO(255, 76, 94, 1),
              size: 16.sp,
            ),
            widthSizedBox(8),
            Text(
              'Cairo, Egypt',
              style: Styles.styles12NormalHalfBlack,
            ),
          ],
        ),
        heightSizedBox(18),
        Text(
          'Location Map',
          style: Styles.styles14w600,
        ),
        heightSizedBox(10),
        Container(
          height: 360.h,
          width: double.infinity,
          color: Colors.red,
        ),
      ],
    );
  }
}

class AboutTabColumn extends StatelessWidget {
  const AboutTabColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSizedBox(12),
          Text(
            'About me',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Text(
            'Dr. Jenny Watson is the top most Immunologists specialist in Christ Hospital at London. She achived several awards for her wonderful contribution in medical field. She is available for private consultation.',
            style: Styles.styles12NormalHalfBlack,
          ),
          heightSizedBox(18),
          Text(
            'Services Provided by Olivia',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Text(
            'Grooming | Walking | Grooming | OnBoarding',
            style: Styles.styles12NormalHalfBlack,
          ),
          heightSizedBox(18),
          Text(
            'Working Time',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Text(
            'Monday - Friday, 08.00 AM - 20.00 PM',
            style: Styles.styles12NormalHalfBlack,
          ),
          heightSizedBox(18),
          Text(
            'More Info',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Row(
            children: [
              Icon(
                Icons.phone_android_outlined,
                color: Colors.black.withOpacity(0.4),
                size: 18.sp,
              ),
              widthSizedBox(8),
              Text(
                '+201016768605',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(5),
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: Colors.black.withOpacity(0.4),
                size: 18.sp,
              ),
              widthSizedBox(8),
              Text(
                'oliviaaustin@gmail.com',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(5),
          Row(
            children: [
              Icon(
                Icons.date_range_outlined,
                color: Colors.black.withOpacity(0.4),
                size: 18.sp,
              ),
              widthSizedBox(8),
              Text(
                '26 years old.',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(18),
          Text(
            'Bookings',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple,
                radius: 6.r,
              ),
              widthSizedBox(8),
              Text(
                '20 Completed bookings',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(5),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: kBlue,
                radius: 6.r,
              ),
              widthSizedBox(8),
              Text(
                '10 Repeated Customers',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(5),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.greenAccent,
                radius: 6.r,
              ),
              widthSizedBox(8),
              Text(
                '6 Repeated bookings',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          /* 
          Should we add more info here and database like 
          Distance willing to travel,
          Accepted Pet Types,
          Accepted Pet size,
          */
        ],
      ),
    );
  }
}

class ProviderProfileCard extends StatelessWidget {
  const ProviderProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 80.h,
          width: 70.w,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/1.png',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        widthSizedBox(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olivia Austin',
              style: Styles.styles16BoldBlack.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            heightSizedBox(6),
            Text(
              'Pet Sitter | Pet Walker | Pet Groomer',
              style: Styles.styles12NormalHalfBlack,
            ),
            heightSizedBox(8),
            const RatingRowWidget(),
          ],
        ),
        // widthSizedBox(10),
        // const Spacer(),
        // Padding(
        //   padding: EdgeInsets.only(right: 4.0.w),
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: Tooltip(
        //       message: 'Send a message to Olivia.',
        //       child: Icon(
        //         FluentIcons.chat_20_regular,
        //         color: kPrimaryGreen,
        //         size: 28.0.sp,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
