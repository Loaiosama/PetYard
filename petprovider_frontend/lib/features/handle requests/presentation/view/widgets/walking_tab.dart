import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/walking_repo/walking_request_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20walking%20request%20cubit/apply_walking_request_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20walking%20request%20cubit/apply_walking_request_states.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/walking%20cubit/walking_request_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/walking%20cubit/walking_request_states.dart';

class WalkingTab extends StatefulWidget {
  const WalkingTab({super.key});

  @override
  State<WalkingTab> createState() => _WalkingTabState();
}

class _WalkingTabState extends State<WalkingTab> {
  final Set<int> _appliedRequests = {};
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => WalkingRequestCubit(
            WalkingRequestRepoImp(api: ApiService(dio: Dio())))
          ..fetchPendingWalkingRequests(),
        child: BlocBuilder<WalkingRequestCubit, WalkingRequestState>(
          builder: (context, state) {
            if (state is WalkingRequestLoading) {
              return const CircularProgressIndicator(
                color: kPrimaryGreen,
              );
            } else if (state is WalkingRequestFailure) {
              print(state.message);
              return const Icon(
                Icons.error,
                color: Colors.red,
              );
            } else if (state is WalkingRequestSuccess) {
              return ListView.builder(
                  itemCount: state.requests.length,
                  itemBuilder: (context, index) {
                    var request = state.requests[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 10.0,
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
                                width: 5.w,
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
                                  create: (context) => ApplyWalkingRequestCubit(
                                      WalkingRequestRepoImp(
                                          api: ApiService(dio: Dio()))),
                                  child: BlocConsumer<ApplyWalkingRequestCubit,
                                      ApplyWalkingRequestState>(
                                    listener: (context, applyState) {
                                      if (state is ApplyWalkingRequestSuccess) {
                                        setState(() {
                                          _appliedRequests
                                              .add(request.reserveId!);
                                        });
                                      }
                                    },
                                    builder: (context, applyState) {
                                      if (_appliedRequests
                                          .contains(request.reserveId)) {
                                        return const Text(
                                          "Applied",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                          ),
                                        );
                                      } else if (applyState
                                          is ApplyWalkingRequestFailure) {
                                        return const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        );
                                      } else if (applyState
                                          is ApplyWalkingRequestLoading) {
                                        return const CircularProgressIndicator(
                                          color: kPrimaryGreen,
                                        );
                                      } else {
                                        return PetYardTextButton(
                                          onPressed: () {
                                            BlocProvider.of<
                                                        ApplyWalkingRequestCubit>(
                                                    context)
                                                .applyWalkingRequest(
                                                    request.reserveId!);

                                            //BlocProvider.of<SittingReqCubit>(context).getAllPendingRequests();
                                          },
                                          text: "Apply",
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
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
