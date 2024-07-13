import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/empty_list.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/SittingRequest.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/handel_req_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20cubit/apply_req_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20cubit/apply_req_states.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/pet%20cubit/pet_info_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/pet%20cubit/pet_info_state.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/sitting_req_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/sitting_req_states.dart';

class SittingTab extends StatefulWidget {
  const SittingTab({Key? key}) : super(key: key);

  @override
  _SittingTabState createState() => _SittingTabState();
}

class _SittingTabState extends State<SittingTab> {
  Position? position;
  final Set<int> _appliedRequests = {};

  Future<String> _configLocation(double? x, double? y) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(x!, y!);
    String loc = "${placemarks[0].locality}";
    return loc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SittingReqCubit(HandelReqRepoImp(api: ApiService(dio: Dio())))
            ..getAllPendingRequests(),
      child: BlocBuilder<SittingReqCubit, SittingReqState>(
        builder: (context, state) {
          if (state is SittingReqLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SittingReqFailure) {
            return const Center(child: Text('No requests for Now '));
          } else if (state is SittingReqSuccess) {
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
                                  HandelReqRepoImp(api: ApiService(dio: Dio())))
                                ..fetchPetInfo(id: request.petId!),
                              child: BlocBuilder<PetInfoCubit, PetInfoState>(
                                builder: (context, petState) {
                                  if (petState is PetInfoLoading) {
                                    return CircleAvatar(
                                      radius: 30.sp,
                                      child: const CircularProgressIndicator(),
                                    );
                                  } else if (petState is PetInfoSuccess) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.pushNamed(Routes.KPetProfile,
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
                                            'assets/images/profile_pictures/${petState.pet.image}'),
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
                                FutureBuilder(
                                  future: _configLocation(
                                      request.location!.x, request.location!.y),
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
                                            children: [
                                              const Icon(
                                                FontAwesomeIcons.locationPin,
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
                                                      .styles12NormalHalfBlack,
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
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/Dog_Sitting.png",
                                      width: 20.w,
                                      height: 20.h,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      "Sitting",
                                      style: Styles.styles14NormalBlack,
                                    )
                                  ],
                                ),
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
                              create: (context) => ApplyReqCubit(
                                  ApplyRequestInitial(),
                                  HandelReqRepoImp(
                                      api: ApiService(dio: Dio()))),
                              child: BlocConsumer<ApplyReqCubit,
                                  ApplyRequestState>(
                                listener: (context, applyState) {
                                  if (applyState is ApplyRequestSuccess) {
                                    setState(() {
                                      _appliedRequests.add(request.reserveId!);
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
                                      is ApplyRequestFailure) {
                                    return const SizedBox();
                                  } else if (applyState
                                      is ApplyRequestLoading) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return PetYardTextButton(
                                      onPressed: () {
                                        BlocProvider.of<ApplyReqCubit>(context)
                                            .applyReq(
                                                reserveId:
                                                    request.reserveId ?? 0);
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const EmptyList(service: "Sitting", type: "Requests");
            }
          } else {
            return const Center(child: Text('Initial State'));
          }
        },
      ),
    );
  }
}
