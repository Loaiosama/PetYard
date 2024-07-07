import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/repo/upcoming_walking_repo_imp.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/presentation/view%20model/fetch_walking_requests_cubit.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/presentation/view%20model/fetch_walking_requests_states.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/presentation/view%20model/start%20walk%20cubit/start_walk_cubit.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/presentation/view%20model/start%20walk%20cubit/start_walk_states.dart';

import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';

class UpcomingWalkingRequests extends StatelessWidget {
  const UpcomingWalkingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => UpcomingWalkingCubit(
          UpcomingWalkingRepoImp(apiService: ApiService(dio: Dio())),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 40.0,
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
                              backgroundImage: NetworkImage(
                                request.petImage ??
                                    "assets/images/profile_dog2.jpg",
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    DateFormat('EEE d MMM yyyy').format(
                                        request.startTime ?? DateTime.now()),
                                    style: Styles.styles12NormalHalfBlack),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                    "${DateFormat("h:mm a").format(request.startTime ?? DateTime.now())} | ${DateFormat("h:mm a").format(request.endTime ?? DateTime.now())}",
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
                              create: (context) => StartWalkingRequestCubit(
                                  UpcomingWalkingRepoImp(
                                      apiService: ApiService(dio: Dio()))),
                              child: BlocConsumer<StartWalkingRequestCubit,
                                  StartWalkingRequestState>(
                                builder: (context, startState) {
                                  if (startState
                                      is StartWalkingRequestLoading) {
                                    return const CircularProgressIndicator(
                                      color: kPrimaryGreen,
                                    );
                                  } else if (startState
                                      is StartWalkingRequestFailure) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  } else {
                                    return PetYardTextButton(
                                      onPressed: () {
                                        BlocProvider.of<
                                                    StartWalkingRequestCubit>(
                                                context)
                                            .startWalkingRequest(
                                                request.reserveId!);
                                      },
                                      text: "Start",
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
                                  if (startState
                                      is StartWalkingRequestSuccess) {
                                    context
                                        .pushNamed(Routes.KTrackWalk, extra: {
                                      'lat': request.ownerLocation!.x,
                                      'long': request.ownerLocation!.y,
                                      'radius': 1000.0
                                    });
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
              return const Center(
                child: Icon(Icons.error),
              );
            }
            return const Center(child: Text('No Requests'));
          },
        ),
      ),
    );
  }
}
