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
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/model/repo/walking_track_repo_imp.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/presentation/view%20model/fetch_walking_requests%20cubit/fetch_wa;ling_requests_cubit.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/presentation/view%20model/fetch_walking_requests%20cubit/fetch_walking_requests._states.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/presentation/view%20model/track%20walking%20cubit/track_walking_cubit.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/presentation/view%20model/track%20walking%20cubit/track_walking_states.dart';

class UpcomingTracking extends StatelessWidget {
  const UpcomingTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Tracking Requests",
          style: Styles.styles18BoldBlack,
        ),
      ),
      body: BlocProvider(
        create: (context) => UpcomingWalkingCubit(
          WalkingTrackRepoImp(apiService: ApiService(dio: Dio())),
        )..fetchUpcomingWalkingRequests(),
        child: BlocBuilder<UpcomingWalkingCubit, UpcomingWalkingState>(
          builder: (context, state) {
            if (state is UpcomingWalkingLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UpcomingWalkingSuccess) {
              return ListView.builder(
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  final startTime = (request.startTime ?? DateTime.now())
                      .add(const Duration(hours: 3));
                  final endTime = (request.endTime ?? DateTime.now())
                      .add(const Duration(hours: 3));
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 20.0,
                    ),
                    child: Material(
                      color: Colors.white,
                      elevation: 3.0.sp,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20.0.sp, top: 20.0.sp, bottom: 20.0.sp),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30.sp,
                              backgroundImage: AssetImage(
                                'assets/images/profile_pictures/${request.petImage}',
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    DateFormat('EEE d MMM yyyy')
                                        .format(startTime),
                                    style: Styles.styles12NormalHalfBlack),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                    "${DateFormat("h:mm a").format(startTime)} | ${DateFormat("h:mm a").format(endTime)}",
                                    style: Styles.styles12NormalHalfBlack),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "${request.finalPrice}EGP",
                                  style: Styles.styles16BoldBlack
                                      .copyWith(color: Colors.green),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            BlocProvider(
                              create: (context) => TrackWalkingRequestCubit(
                                  WalkingTrackRepoImp(
                                      apiService: ApiService(dio: Dio()))),
                              child: BlocConsumer<TrackWalkingRequestCubit,
                                  TrackWalkingState>(
                                builder: (context, startState) {
                                  if (startState is TrackWalkingLoading) {
                                    return const CircularProgressIndicator(
                                      color: kPrimaryGreen,
                                    );
                                  } else {
                                    return PetYardTextButton(
                                      onPressed: () {
                                        BlocProvider.of<
                                                    TrackWalkingRequestCubit>(
                                                context)
                                            .startWalkingRequest(
                                                request.reserveId!);
                                      },
                                      text: "Track",
                                      style: Styles.styles12NormalHalfBlack
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 16),
                                      color: kPrimaryGreen,
                                      width: 65.w,
                                      radius: 8.r,
                                      height: 30.h,
                                    );
                                  }
                                },
                                listener: (context, startState) {
                                  if (startState is TrackWalkingSuccess) {
                                    context
                                        .pushNamed(Routes.KTrackWalk, extra: {
                                      'lat': request.geofenceLatitude,
                                      'long': request.geofenceLongitude,
                                      'radius': request.geofenceRadius,
                                    });
                                  } else if (startState
                                      is TrackWalkingFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(startState.message),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is UpcomingWalkingFailure) {
              print(state.message);
              return Center(
                child: Text(state.message),
              );
            }
            return const Center(child: Text('No Requests'));
          },
        ),
      ),
    );
  }
}
