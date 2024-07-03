import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
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
                  BlocProvider(
                    create: (context) => AppointmentsHistoryCubit(
                        AppointmentHistoryImpl(
                            apiService: ApiService(dio: Dio())))
                      ..fetchAcceptedReservations(),
                    child: const UpcomingTabColumn(),
                  ),
                  BlocProvider(
                    create: (context) => AppointmentsHistoryCubit(
                      AppointmentHistoryImpl(
                          apiService: ApiService(dio: Dio())),
                    )..fetchPendingReservations(),
                    child: const PendingTabColumn(),
                  ),
                  BlocProvider(
                    create: (context) => AppointmentsHistoryCubit(
                      AppointmentHistoryImpl(
                          apiService: ApiService(dio: Dio())),
                    )..fetchCompletedReservations(),
                    child: const CompletedTabColumn(),
                  ),
                  BlocProvider(
                    create: (context) => AppointmentsHistoryCubit(
                      AppointmentHistoryImpl(
                          apiService: ApiService(dio: Dio())),
                    )..fetchRejectedReservations(),
                    child: const CancelledTabColumn(),
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
          return pendingReservations.isNotEmpty
              ? ListView.builder(
                  itemCount: pendingReservations.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CompletedCancelledPendingTabCard(
                      slotPrice: state
                              .pendingReservations[index].data![0].finalPrice ??
                          0.0,
                      boardingStartDate:
                          state.pendingReservations[index].data?[0].startTime,
                      boardingEndDate:
                          state.pendingReservations[index].data?[0].endTime,
                      providerImage: state.pendingReservations[index].data?[0]
                              .providerImage ??
                          '',
                      providerName: state.pendingReservations[index].data?[0]
                              .providerName ??
                          'no name',
                      service: state.pendingReservations[index].data?[0]
                              .serviceType ??
                          'no service',
                      appointmentStatus: 'Appointment Pending.',
                      statusColor: Colors.yellow.shade700,
                      status: 'pending',
                    );
                  },
                )
              : const EmptyTabWidget(
                  status: 'pending',
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
    return BlocBuilder<AppointmentsHistoryCubit, AppointmentsHistoryState>(
      builder: (context, state) {
        if (state is RejectedAppointmentLoading) {
          return ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return const CompletedPendingCancelledShimmerCard();
            },
          );
        } else if (state is RejectedAppointmentSuccess) {
          List canceledReservations = state.rejectedReservations;
          return canceledReservations.isNotEmpty
              ? ListView.builder(
                  itemCount: canceledReservations.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CompletedCancelledPendingTabCard(
                      slotPrice: state
                              .rejectedReservations[index].data![0].slotPrice ??
                          0.0,
                      boardingStartDate:
                          state.rejectedReservations[index].data?[0].startTime,
                      boardingEndDate:
                          state.rejectedReservations[index].data?[0].endTime,
                      providerImage: state.rejectedReservations[index].data?[0]
                              .providerImage ??
                          '',
                      providerName: state.rejectedReservations[index].data?[0]
                              .providerName ??
                          'no name',
                      service: state.rejectedReservations[index].data?[0]
                              .serviceType ??
                          'no service',
                      appointmentStatus: 'Appointment Cancelled.',
                      statusColor: Colors.red,
                      status: 'canceled',
                    );
                  },
                )
              : const EmptyTabWidget(
                  status: 'canceled',
                );
        } else if (state is RejectedAppointmentFailure) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Text('oops!');
        }
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
          return completedReservations.isNotEmpty
              ? ListView.builder(
                  itemCount: completedReservations.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CompletedCancelledPendingTabCard(
                      providerId: state.completedReservations[index].data?[0]
                              .providerId ??
                          -1,
                      boardingStartDate:
                          state.completedReservations[index].data?[0].startTime,
                      boardingEndDate:
                          state.completedReservations[index].data?[0].endTime,
                      providerImage: state.completedReservations[index].data?[0]
                              .providerImage ??
                          '',
                      providerName: state.completedReservations[index].data?[0]
                              .providerName ??
                          'no name',
                      service: state.completedReservations[index].data?[0]
                              .serviceType ??
                          'no service',
                      appointmentStatus: 'Appointment Done.',
                      statusColor: kPrimaryGreen,
                      slotPrice:
                          state.completedReservations[0].data![0].slotPrice ??
                              0.0,
                      status: 'completed',
                    );
                  },
                )
              : const EmptyTabWidget(status: 'completed');
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
    return BlocBuilder<AppointmentsHistoryCubit, AppointmentsHistoryState>(
      builder: (context, state) {
        if (state is AcceptedAppointmentLoading) {
          return ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return const CompletedPendingCancelledShimmerCard();
            },
          );
        } else if (state is AcceptedAppointmentSuccess) {
          List acceptedReservations = state.acceptedReservations;
          return acceptedReservations.isNotEmpty
              ? ListView.builder(
                  itemCount: acceptedReservations.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return UpcomingAppointmentCard(
                      // providerID: state.acceptedReservations[index].data?[0]
                      //         .providerId ??
                      //     -1,
                      providerImage: state.acceptedReservations[index].data?[0]
                              .providerImage ??
                          '',
                      providerName: state.acceptedReservations[index].data?[0]
                              .providerName ??
                          'No name',
                      service: state.acceptedReservations[index].data?[0]
                              .serviceType ??
                          'no service type',
                      boardingEndDate:
                          state.acceptedReservations[index].data?[0].endTime,
                      boardingStartDate:
                          state.acceptedReservations[index].data?[0].startTime,
                    );
                  },
                )
              : const EmptyTabWidget(status: 'completed');
        } else if (state is AcceptedAppointmentFailure) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Text('oops!');
        }
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

class EmptyTabWidget extends StatelessWidget {
  const EmptyTabWidget({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200.h,
          width: 200.w,
          child: SvgPicture.asset(
            'assets/svgs/sad_pet.svg',
            fit: BoxFit.cover,
          ),
        ),
        heightSizedBox(10),
        Text(
          'There is no $status reservations.',
          style: Styles.styles12NormalHalfBlack,
        ),
      ],
    );
  }
}
