import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/empty_list.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/applications/data/model/pending_sitting_req.dart';
import 'package:petowner_frontend/features/applications/data/model/update_application.dart';
import 'package:petowner_frontend/features/applications/data/repo/sitting_app_repo_imp.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/Sitting_app_states.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/sitting_app_cubit.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/update%20sitting%20application%20cubit/update_sitting_app_cubit.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/update%20sitting%20application%20cubit/update_sitting_app_states.dart';

class SittingApplications extends StatefulWidget {
  final PendingSittingReq req;
  const SittingApplications({super.key, required this.req});

  @override
  State<SittingApplications> createState() => _SittingApplicationsState();
}

class _SittingApplicationsState extends State<SittingApplications> {
  @override
  Widget build(BuildContext context) {
    final Set<int> rejected = {};
    return Scaffold(
      body: BlocProvider(
          create: (context) => SittingApplicationsCubit(
              SittingAppRepoImp(api: ApiService(dio: Dio())))
            ..fetchSittingApplications(widget.req.reserveId!),
          child: BlocBuilder<SittingApplicationsCubit, SittingAppState>(
            builder: (context, state) {
              if (state is SittingAppLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryGreen,
                  ),
                );
              } else if (state is SittingAppFailure) {
                print(state.message);
                return const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                );
              } else if (state is SittingAppSuccess) {
                if (state.applications.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: ListView.builder(
                      itemCount: state.applications.length,
                      itemBuilder: (context, index) {
                        var app = state.applications[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 40.0.h,
                          ),
                          child: Material(
                            elevation: 2.0.sp,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: EdgeInsets.all(20.0.sp),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30.sp,
                                    backgroundImage: const NetworkImage(
                                      "assets/images/profile_dog2.jpg",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0.w),
                                        child: Text(
                                            app.providerName ?? "No Name",
                                            style: Styles.styles16w600),
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
                                    ],
                                  ),
                                  const Spacer(),
                                  BlocProvider(
                                      create: (context) => ApplicationCubit(
                                          sittingAppRepo: SittingAppRepoImp(
                                              api: ApiService(dio: Dio()))),
                                      child: BlocConsumer<ApplicationCubit,
                                          ApplicationState>(
                                        builder: (context, appState) {
                                          if (rejected.contains(index)) {
                                            return Text(
                                              "Rejected",
                                              style: Styles.styles16BoldBlack
                                                  .copyWith(color: Colors.red),
                                            );
                                          } else if (appState
                                              is ApplicationLoading) {
                                            return const CircularProgressIndicator(
                                              color: kPrimaryGreen,
                                            );
                                          } else if (appState
                                              is ApplicationFailure) {
                                            return const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            );
                                          } else {
                                            return Column(
                                              children: [
                                                PetYardTextButton(
                                                  onPressed: () {
                                                    UpdateApplication
                                                        updateApplication =
                                                        UpdateApplication(
                                                      providerID:
                                                          app.providerId,
                                                      reserveID: app.reserveId,
                                                    );
                                                    BlocProvider.of<
                                                                ApplicationCubit>(
                                                            context)
                                                        .acceptApplication(
                                                            updateApplication);
                                                  },
                                                  text: "Accept",
                                                  style: Styles
                                                      .styles12NormalHalfBlack
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                  color: Colors.green,
                                                  width: 42.w,
                                                  radius: 8.r,
                                                  height: 15.h,
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                PetYardTextButton(
                                                  onPressed: () {
                                                    UpdateApplication
                                                        updateApplication =
                                                        UpdateApplication(
                                                      providerID:
                                                          app.providerId,
                                                      reserveID: app.reserveId,
                                                    );
                                                    BlocProvider.of<
                                                                ApplicationCubit>(
                                                            context)
                                                        .rejectApplication(
                                                            updateApplication);
                                                    setState(() {
                                                      rejected.add(index);
                                                    });
                                                  },
                                                  text: " Reject ",
                                                  style: Styles
                                                      .styles12NormalHalfBlack
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                  color: Colors.red,
                                                  width: 42.w,
                                                  radius: 8.r,
                                                  height: 15.h,
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                        listener: (context, state) {
                                          if (state is ApplicationSuccess) {}
                                        },
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                      child: EmptyList(
                    service: "Sitting",
                    type: "Applications",
                  ));
                }
              } else {
                return const SizedBox();
              }
            },
          )),
    );
  }
}
