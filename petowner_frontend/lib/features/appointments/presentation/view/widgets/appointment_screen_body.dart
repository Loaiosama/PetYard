import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'completed_cancelled_pending_card.dart';
import 'upcoming_appointment_card.dart';

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
        return CompletedCancelledPendingTabCard(
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
        return const CompletedCancelledPendingTabCard(
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
        return const CompletedCancelledPendingTabCard(
          appointmentStatus: 'Appointment Done.',
          statusColor: kPrimaryGreen,
        );
      },
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
