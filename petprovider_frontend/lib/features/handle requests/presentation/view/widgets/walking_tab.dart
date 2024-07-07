import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/empty_list.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/handel_req_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/walking_repo/walking_request_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20walking%20request%20cubit/apply_walking_request_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20walking%20request%20cubit/apply_walking_request_states.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/pet%20cubit/pet_info_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/pet%20cubit/pet_info_state.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/walking%20cubit/walking_request_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/walking%20cubit/walking_request_states.dart';

class WalkingTab extends StatefulWidget {
  const WalkingTab({super.key});

  @override
  State<WalkingTab> createState() => _WalkingTabState();
}

class _WalkingTabState extends State<WalkingTab> {
  final Set<int> _appliedRequests = {};
  Future<String> _configLocation(double? x, double? y) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(x!, y!);
    String loc = "${placemarks[0].locality}";
    return loc;
  }

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
              if (state.requests.isNotEmpty) {
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
                                BlocProvider(
                                  create: (context) => PetInfoCubit(
                                      PetInfoInitial(),
                                      HandelReqRepoImp(
                                          api: ApiService(dio: Dio())))
                                    ..fetchPetInfo(id: request.petId!),
                                  child:
                                      BlocBuilder<PetInfoCubit, PetInfoState>(
                                    builder: (context, petState) {
                                      if (petState is PetInfoLoading) {
                                        return CircleAvatar(
                                          radius: 30.sp,
                                          child:
                                              const CircularProgressIndicator(),
                                        );
                                      } else if (petState is PetInfoSuccess) {
                                        return GestureDetector(
                                          onTap: () {
                                            context.pushNamed(
                                                Routes.KPetProfile,
                                                extra: {
                                                  'pet': petState.pet,
                                                  'age': petState.age,
                                                  'ownerId': request.ownerId,
                                                  // Pass ownerId here
                                                });
                                          },
                                          child: CircleAvatar(
                                            radius: 30.sp,
                                            backgroundImage: NetworkImage(
                                              petState.pet.image ??
                                                  "assets/images/profile_dog2.jpg",
                                            ),
                                          ),
                                        );
                                      } else if (petState is PetInfofaliure) {
                                        return CircleAvatar(
                                          radius: 30.r,
                                          child: const Icon(Icons.error),
                                        );
                                      } else {
                                        return CircleAvatar(
                                          radius: 30.sp,
                                          child: const Icon(Icons.pets),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.0.w),
                                      child: Text(
                                          DateFormat('EEE d MMM yyyy').format(
                                              request.startTime ??
                                                  DateTime.now()),
                                          style:
                                              Styles.styles12NormalHalfBlack),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.0.w),
                                      child: Text(
                                          "${DateFormat("h:mm a").format(request.startTime ?? DateTime.now())} | ${DateFormat("h:mm a").format(request.endTime ?? DateTime.now())}",
                                          style:
                                              Styles.styles12NormalHalfBlack),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.0.w),
                                      child: Text(
                                        "${request.finalPrice}EGP",
                                        style: Styles.styles16BoldBlack
                                            .copyWith(color: Colors.green),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    FutureBuilder(
                                      future: _configLocation(
                                          request.centerLatitude,
                                          request.centerLongitude),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator(
                                            color: kPrimaryGreen,
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            "Error loading location",
                                            style: Styles.styles16BoldBlack
                                                .copyWith(color: Colors.black),
                                          );
                                        } else if (snapshot.hasData) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    FontAwesomeIcons
                                                        .locationPin,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  SizedBox(
                                                    width: 80.w,
                                                    child: Text(
                                                      snapshot.data!,
                                                      style: Styles
                                                          .styles12NormalHalfBlack
                                                          .copyWith(
                                                              fontSize: 10),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Spacer(),
                                BlocProvider(
                                    create: (context) =>
                                        ApplyWalkingRequestCubit(
                                            WalkingRequestRepoImp(
                                                api: ApiService(dio: Dio()))),
                                    child: BlocConsumer<
                                        ApplyWalkingRequestCubit,
                                        ApplyWalkingRequestState>(
                                      listener: (context, applyState) {
                                        if (applyState
                                            is ApplyWalkingRequestSuccess) {
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
                                            style: Styles
                                                .styles12NormalHalfBlack
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
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const EmptyList(service: "Walking", type: "Requests");
              }
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
