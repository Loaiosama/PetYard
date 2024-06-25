import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/appointments%20history/data/repo/appointment_histor_repo_impl.dart';
import 'package:petowner_frontend/features/appointments%20history/presentation/view%20model/appointments%20history/appointments_history_cubit.dart';
import 'package:shimmer/shimmer.dart';
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
              child: TabBarView(
                children: [
                  const UpcomingTabColumn(),
                  BlocProvider(
                    create: (context) => AppointmentsHistoryCubit(
                        AppointmentHistoryImpl(
                            apiService: ApiService(dio: Dio())))
                      ..fetchPendingReservations(),
                    child: const PendingTabColumn(),
                  ),
                  BlocProvider(
                    create: (context) => AppointmentsHistoryCubit(
                        AppointmentHistoryImpl(
                            apiService: ApiService(dio: Dio())))
                      ..fetchCompletedReservations(),
                    child: const CompletedTabColumn(),
                  ),
                  const CancelledTabColumn(),
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
    return BlocBuilder<AppointmentsHistoryCubit, AppointmentsHistoryState>(
      builder: (context, state) {
        if (state is PendingAppointmentLoading) {
          return ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return const CompletedPendingCancelledShimmerCard();
            },
          );
        } else if (state is PendingAppointmentSuccess) {
          List pendingReservations = state.pendingReservations;
          return ListView.builder(
            itemCount: pendingReservations.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return CompletedCancelledPendingTabCard(
                boardingStartDate:
                    state.pendingReservations[index].data?[0].startTime,
                boardingEndDate:
                    state.pendingReservations[index].data?[0].endTime,
                providerImage:
                    state.pendingReservations[index].data?[0].providerImage ??
                        '',
                providerName:
                    state.pendingReservations[index].data?[0].providerName ??
                        'no name',
                service:
                    state.pendingReservations[index].data?[0].serviceType ??
                        'no service',
                appointmentStatus: 'Appointment Pending.',
                statusColor: Colors.yellow.shade700,
              );
            },
          );
        } else if (state is PendingAppointmentFailure) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Text('oops!');
        }
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
          providerImage: '',
          providerName: '',
          service: '',
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
    return BlocBuilder<AppointmentsHistoryCubit, AppointmentsHistoryState>(
      builder: (context, state) {
        if (state is CompletedAppointmentsLoading) {
          return ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return const CompletedPendingCancelledShimmerCard();
            },
          );
        } else if (state is CompletedAppointmentsSuccses) {
          List completedReservations = state.completedReservations;
          return ListView.builder(
            itemCount: completedReservations.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return CompletedCancelledPendingTabCard(
                boardingStartDate:
                    state.completedReservations[index].data?[0].startTime,
                boardingEndDate:
                    state.completedReservations[index].data?[0].endTime,
                providerImage:
                    state.completedReservations[index].data?[0].providerImage ??
                        '',
                providerName:
                    state.completedReservations[index].data?[0].providerName ??
                        'no name',
                service:
                    state.completedReservations[index].data?[0].serviceType ??
                        'no service',
                appointmentStatus: 'Appointment Done.',
                statusColor: kPrimaryGreen,
              );
            },
          );
        } else if (state is CompletedAppointmentsFailure) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Text('oops!');
        }
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

class CompletedPendingCancelledShimmerCard extends StatelessWidget {
  const CompletedPendingCancelledShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Material(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 14.0.h, left: 16.0.w, bottom: 14.0.h),
              child: Column(
                children: [
                  Container(
                    width: 150.w,
                    height: 44.h,
                    color: Colors.white,
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 16.0.w,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 80.h,
                          width: 70.w,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
