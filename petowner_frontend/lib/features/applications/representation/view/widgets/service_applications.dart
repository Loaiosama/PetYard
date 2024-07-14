import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/empty_list.dart';

import 'package:petowner_frontend/features/applications/data/repo/sitting_app_repo_imp.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/pending%20requests%20cubit/pending_sittin_req_cubit.dart';

import 'package:petowner_frontend/features/applications/representation/view%20model/pending%20requests%20cubit/pending_sitting_req_states.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/walking%20app%20cubit/walking_app_states.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/walking%20request%20cubit/pending_walking_request_cubit.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/walking%20request%20cubit/pending_walking_request_states.dart';

class ServiceApplications extends StatelessWidget {
  final String service;
  const ServiceApplications({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return service == "Sitting"
        ? BlocProvider(
            create: (context) => PendingSittingRequestsCubit(
                SittingAppRepoImp(api: ApiService(dio: Dio())))
              ..fetchPendingSittingRequests(),
            child: BlocBuilder<PendingSittingRequestsCubit,
                PendingSittingRequestsState>(
              builder: (context, state) {
                if (state is PendingSittingRequestsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryGreen,
                    ),
                  );
                } else if (state is PendingSittingRequestsFailure) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is PendingSittingRequestsSuccess) {
                  if (state.requests.isNotEmpty) {
                    return ListView.builder(
                      itemCount: state.requests.length,
                      itemBuilder: (context, index) {
                        var req = state.requests[index];
                        final startTime = (req.startTime ?? DateTime.now())
                            .add(const Duration(hours: 3));
                        final endTime = (req.endTime ?? DateTime.now())
                            .add(const Duration(hours: 3));
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0.w, vertical: 10.0.h),
                          child: Material(
                            elevation: 2.0.sp,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0.sp, top: 20.0.sp, bottom: 20.0.sp),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      radius: 30.sp,
                                      backgroundImage: AssetImage(
                                          'assets/images/profile_pictures/${req.image}')),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0.w),
                                        child: Text(req.name ?? "No Name",
                                            style: Styles.styles16w600),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0.w),
                                        child: Text(
                                            DateFormat('EEE d MMM yyyy')
                                                .format(startTime),
                                            style:
                                                Styles.styles12NormalHalfBlack),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0.w),
                                        child: Text(
                                            "${DateFormat("h:mm a").format(startTime)} | ${DateFormat("h:mm a").format(endTime)}",
                                            style:
                                                Styles.styles12NormalHalfBlack),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                              "assets/images/Dog_Sitting.png"),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            "Pet Sitting",
                                            style: Styles.styles14NormalBlack,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text("${req.finalPrice.toString()}EGP",
                                          style: Styles.styles16w600
                                              .copyWith(color: Colors.green)),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      print("==========");
                                      print(req.name);
                                      print("==========");

                                      context.pushNamed(
                                          Routes.KSittingApplications,
                                          extra: req);
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    color: kPrimaryGreen,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: EmptyList(
                      service: "Sitting",
                      type: "Requests",
                    ));
                  }
                } else {
                  return const Center(
                    child: Text("Unexpected state"),
                  );
                }
              },
            ),
          )
        : BlocProvider(
            create: (context) => WalkingRequestsCubit(
                SittingAppRepoImp(api: ApiService(dio: Dio())))
              ..fetchWalkingRequests(),
            child: BlocBuilder<WalkingRequestsCubit, WalkingRequestsState>(
              builder: (context, state) {
                if (state is WalkingRequestsLoading) {
                  return const CircularProgressIndicator(
                    color: kPrimaryGreen,
                  );
                } else if (state is WalkingRequestsFailure) {
                  // print(state.message);
                  return const Icon(
                    Icons.error,
                    color: Colors.red,
                  );
                } else if (state is WalkingRequestsSuccess) {
                  if (state.walkingRequests.isNotEmpty) {
                    return ListView.builder(
                      itemCount: state.walkingRequests.length,
                      itemBuilder: (context, index) {
                        var req = state.walkingRequests[index];
                        final startTime = (req.startTime ?? DateTime.now())
                            .add(const Duration(hours: 3));
                        final endTime = (req.endTime ?? DateTime.now())
                            .add(const Duration(hours: 3));
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0.w, vertical: 10.0.h),
                          child: Material(
                            elevation: 2.0.sp,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0.sp, top: 20.0.sp, bottom: 20.0.sp),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      radius: 30.sp,
                                      backgroundImage: AssetImage(
                                          'assets/images/profile_pictures/${req.image}')),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0.w),
                                        child: Text(req.name ?? "No Name",
                                            style: Styles.styles16w600),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0.w),
                                        child: Text(
                                            DateFormat('EEE d MMM yyyy')
                                                .format(startTime),
                                            style:
                                                Styles.styles12NormalHalfBlack),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0.w),
                                        child: Text(
                                            "${DateFormat("h:mm a").format(startTime)} | ${DateFormat("h:mm a").format(endTime)}",
                                            style:
                                                Styles.styles12NormalHalfBlack),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "assets/images/walking_icon.png",
                                            width: 25.h,
                                            height: 25.h,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            "Pet Walking",
                                            style: Styles.styles14NormalBlack,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text("${req.finalPrice.toString()}EGP",
                                          style: Styles.styles16w600
                                              .copyWith(color: Colors.green)),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      context.pushNamed(
                                          Routes.KWalkingApplications,
                                          extra: req);
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    color: kPrimaryGreen,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: EmptyList(
                      service: "Sitting",
                      type: "Requests",
                    ));
                  }
                } else {
                  return const SizedBox();
                }
              },
            ));
  }
}
