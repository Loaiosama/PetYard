import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/pet_carer_card.dart';

class AppointmentsScreenBody extends StatelessWidget {
  const AppointmentsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Padding(
        padding: EdgeInsets.only(top: 24.0.h, right: 16.0.w, left: 16.0.w),
        child: Column(
          children: [
            TabBar(
              // controller: tabController,
              labelStyle: Styles.styles14w600.copyWith(color: kPrimaryGreen),
              unselectedLabelStyle:
                  Styles.styles12RegularOpacityBlack.copyWith(fontSize: 14.sp),
              indicatorColor: kPrimaryGreen,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.only(bottom: 4.0.h),
              physics: const BouncingScrollPhysics(),
              tabs: const [
                Text('Upcoming'),
                Text('Pending'),
                Text('Completed'),
                Text('Cancelled'),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6924,
              margin: EdgeInsets.only(top: 20.0.h),
              child: const TabBarView(
                // controller: tabController,
                children: [
                  UpcomingTabColumn(),
                  PendingTabColumn(),
                  CompletedTabColumn(),
                  CancelledTabColumn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PendingTabColumn extends StatelessWidget {
  const PendingTabColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return CompletedCancelledTabCard(
          appointmentStatus: 'Appointment Pending.',
          statusColor: Colors.yellow.shade700,
        );
      },
    );
  }
}

class CancelledTabColumn extends StatelessWidget {
  const CancelledTabColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return const CompletedCancelledTabCard(
          appointmentStatus: 'Appointment Cancelled.',
          statusColor: Colors.red,
        );
      },
    );
  }
}

class CompletedTabColumn extends StatelessWidget {
  const CompletedTabColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return const CompletedCancelledTabCard(
          appointmentStatus: 'Appointment Done.',
          statusColor: kPrimaryGreen,
        );
      },
    );
  }
}

class CompletedCancelledTabCard extends StatelessWidget {
  const CompletedCancelledTabCard({
    super.key,
    required this.appointmentStatus,
    required this.statusColor,
  });
  final String appointmentStatus;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Material(
        elevation: 1.0,
        type: MaterialType.card,
        // borderRadius: BorderRadius.circular(10.0.r),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.08),
          ),
        ),
        color: Colors.white,
        child: SizedBox(
          height: 181,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 14.0.h, left: 16.0.w, bottom: 14.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointmentStatus,
                          style: Styles.styles12RegularOpacityBlack.copyWith(
                            color: statusColor,
                          ),
                        ),
                        heightSizedBox(4),
                        Text(
                          'Wed, 17 May | 08.30 AM',
                          style: Styles.styles12RegularOpacityBlack,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Tooltip(
                        message: 'More',
                        child: Icon(
                          Icons.more_vert_outlined,
                          color: Colors.black.withOpacity(0.5),
                          size: 22.0.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 16.0.w,
                  ),
                  child: const Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 16.0.w,
                  ),
                  child: Row(
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
                          heightSizedBox(4),
                          Text(
                            'Pet Sitting',
                            style: Styles.styles12NormalHalfBlack,
                          ),
                          heightSizedBox(2),
                          const RatingRowWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpcomingTabColumn extends StatelessWidget {
  const UpcomingTabColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return const UpcomingAppointmentCard();
      },
    );
  }
}

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Material(
        elevation: 1.0,
        type: MaterialType.card,
        // borderRadius: BorderRadius.circular(10.0.r),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.08),
          ),
        ),
        color: Colors.white,
        child: SizedBox(
          height: 181,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 14.0.h, left: 16.0.w, right: 16.0.w),
            child: Column(
              children: [
                Row(
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
                        heightSizedBox(4),
                        Text(
                          'Pet Sitting',
                          style: Styles.styles12NormalHalfBlack,
                        ),
                        heightSizedBox(2),
                        Text(
                          'Wed, 17 May | 08.30 AM',
                          style: Styles.styles12NormalHalfBlack,
                        ),
                      ],
                    ),
                    // widthSizedBox(10),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Tooltip(
                        message: 'Send a message to Olivia.',
                        child: Icon(
                          FluentIcons.chat_20_regular,
                          color: kPrimaryGreen,
                          size: 28.0.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                heightSizedBox(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PetYardTextButton(
                      onPressed: () {},
                      width: 140.w,
                      height: 50.h,
                      radius: 24.0.r,
                      color: Colors.transparent,
                      borderColor: kPrimaryGreen,
                      text: 'Cancel Appointment',
                      style: Styles.styles14w600.copyWith(
                        color: kPrimaryGreen,
                        fontSize: 11.sp,
                      ),
                    ),
                    PetYardTextButton(
                      onPressed: () {},
                      width: 140.w,
                      height: 50.h,
                      radius: 24.0.r,
                      text: 'Reschedule',
                      style: Styles.styles14w600.copyWith(
                        color: Colors.white,
                        fontSize: 11.sp,
                      ),
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
