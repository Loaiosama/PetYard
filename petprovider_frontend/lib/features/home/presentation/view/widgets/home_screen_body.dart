// ignore_for_file: use_build_context_synchronously

// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/constants/constants.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/green_container_at_top.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/grooming/data/repo/grooming_repo_impl.dart';
import 'package:petprovider_frontend/features/home/data/models/profile_info/datum.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo_impl.dart';
import 'package:petprovider_frontend/features/home/presentation/view%20model/upcoming_events/upcoming_events_cubit.dart';
import 'package:petprovider_frontend/features/home/presentation/view%20model/profile_info_cubit/profile_info_cubit.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/repo/upcoming_walking_repo.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/repo/upcoming_walking_repo_imp.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/presentation/view%20model/start%20walk%20cubit/start_walk_cubit.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/presentation/view%20model/start%20walk%20cubit/start_walk_states.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileInfoCubit(HomeRepoImppl(api: ApiService(dio: Dio())))
            ..fetchProviderInfo(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
            builder: (context, state) {
              if (state is ProfileInfoSuccess) {
                return Column(
                  children: [
                    GreenContainerAtTop(
                      title:
                          'Hello, ${state.profileInfo.providerinfo?[0].username ?? 'no name'}!',
                      subTitle:
                          'Set your working hours to start earning. And monitor all your upcoming events to stay up to date!',
                    ),
                    heightSizedBox(20),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.w, right: 16.w, bottom: 10.h),
                      child: Column(
                        children: [
                          SetAvailableSlotsColumn(
                            services: state.profileInfo.data ?? [],
                          ),
                          // heightSizedBox(16),
                          PetYardTextButton(
                            onPressed: () {
                              GoRouter.of(context)
                                  .push(Routes.kUpcomingWalkingRequests);
                            },
                            text: 'Start Walking Reqeusts',
                            style: Styles.styles16BoldWhite,
                            height: 50.h,
                          ),
                          const UpComingEventsColumn(),
                        ],
                      ),
                    ),

                    // Text('data'),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class SetAvailableSlotsColumn extends StatelessWidget {
  const SetAvailableSlotsColumn({super.key, required this.services});

  final List<Datum> services;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set available slots',
          style: Styles.styles18SemiBoldBlack,
        ),
        heightSizedBox(12),
        SetAvailableListView(
          services: services,
        ),
      ],
    );
  }
}

class SetAvailableListView extends StatelessWidget {
  const SetAvailableListView({super.key, required this.services});

  final List<Datum> services;

  @override
  Widget build(BuildContext context) {
    double calculateHeight(BuildContext context, int length) {
      if (length == 1) {
        return MediaQuery.of(context).size.height * 0.20;
      } else if (length == 2) {
        return MediaQuery.of(context).size.height * 0.25;
      } else if (length == 3) {
        return MediaQuery.of(context).size.height * 0.35;
      } else {
        return MediaQuery.of(context).size.height * 0.48;
      }
    }

    void navigateToChooseGroomingTypes(BuildContext context) async {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
                child: CircularProgressIndicator(
              color: kPrimaryGreen,
            ));
          },
        );
        GroomingRepoImpl groomingRepoImpl =
            GroomingRepoImpl(api: ApiService(dio: Dio()));
        var result = await groomingRepoImpl.getGroomingTypeForHome();
        await Future.delayed(const Duration(seconds: 1));

        Navigator.pop(context); // Remove the loading indicator

        // result.fold(
        //   (failure) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(content: Text('Something went wrong')));
        //   },
        //   (message) {
        //     if (message == 'Set Slot') {
        //       GoRouter.of(context)
        //           .push(Routes.kAvailableSlotsScreen, extra: 'Grooming');
        //     } else {
        //       GoRouter.of(context)
        //           .push(Routes.kChooseGroomingTypes, extra: 'Grooming');
        //     }
        //   },
        // );
        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Something went wrong')));
          },
          (types) {
            if (types.isNotEmpty) {
              GoRouter.of(context).push(Routes.kAvailableSlotsScreen, extra: {
                "serviceName": "Grooming",
                "groomingTypes": types,
              });
            } else {
              GoRouter.of(context).push(Routes.kChooseGroomingTypes, extra: {
                "groomingTypes": [],
                "serviceName": "Grooming",
              });
            }
          },
        );
      } catch (e) {
        Navigator.pop(
            context); // Remove the loading indicator if an error occurs
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
      }
    }

    // ##########################################################
    // the use of cached grooming types
    // void navigateToChooseGroomingTypes(BuildContext context) async {
    //   try {
    //     // Show loading indicator
    //     // showDialog(
    //     //   context: context,
    //     //   barrierDismissible: false,
    //     //   builder: (BuildContext context) {
    //     //     return const Center(child: CircularProgressIndicator());
    //     //   },
    //     // );
    //     const FlutterSecureStorage storage = FlutterSecureStorage();

    //     // Ensure loading indicator is visible for at least 1 second
    //     // await Future.delayed(const Duration(seconds: 1));

    //     // Retrieve cached grooming types
    //     String? cachedGroomingTypes = await storage.read(key: 'groomingTypes');
    //     List<dynamic> groomingTypes =
    //         cachedGroomingTypes != null ? jsonDecode(cachedGroomingTypes) : [];

    //     // Navigator.of(context).pop(); // Remove loading indicator

    //     if (groomingTypes.isNotEmpty) {
    //       GoRouter.of(context)
    //           .push(Routes.kAvailableSlotsScreen, extra: 'Grooming');
    //     } else {
    //       GoRouter.of(context)
    //           .push(Routes.kChooseGroomingTypes, extra: 'Grooming');
    //     }
    //   } catch (e) {
    //     Navigator.of(context).pop(); // Remove loading indicator
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Something went wrong')),
    //     );
    //   }
    // }

    return SizedBox(
      height: calculateHeight(context, services.length),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.0.h),
            child: Material(
              color: Colors.white,
              elevation: 2.0,
              borderRadius: BorderRadius.circular(10.0.r),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      services[index].type ?? 'no service name',
                      style: Styles.styles14NormalBlack,
                    ),
                    services[index].type == 'Sitting' ||
                            services[index].type == 'Walking'
                        ? const SizedBox()
                        : IconButton(
                            onPressed: () {
                              if (services[index].type == 'Boarding') {
                                GoRouter.of(context)
                                    .push(Routes.kAvailableSlotsScreen, extra: {
                                  "serviceName": services[index].type,
                                  "groomingTypes": [],
                                });
                              } else if (services[index].type == 'Grooming') {
                                navigateToChooseGroomingTypes(context);
                              }
                            },
                            icon: const Tooltip(
                                message: 'Set new slot',
                                child: Icon(Icons.arrow_forward_ios)),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UpComingEventsColumn extends StatelessWidget {
  const UpComingEventsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpcomingEventsCubit(HomeRepoImppl(api: ApiService(dio: Dio())))
            ..fetchUpcomingEvents(),
      child: BlocBuilder<UpcomingEventsCubit, UpcomingEventsState>(
        builder: (context, state) {
          if (state is UpcomingEventsLoading) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming events',
                      style: Styles.styles18SemiBoldBlack,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(color: kPrimaryGreen),
                      ),
                    ),
                  ],
                ),
                heightSizedBox(12),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Material(
                    color: Colors.white,
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0.h, horizontal: 14.w),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26.0.r,
                            backgroundColor: Colors.grey[300],
                          ),
                          widthSizedBox(16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 120.w,
                                height: 12.h,
                                color: Colors.grey[300],
                              ),
                              heightSizedBox(8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.shoePrints,
                                    size: 16.sp,
                                    color: Colors.grey[300],
                                  ),
                                  widthSizedBox(10),
                                  Container(
                                    width: 80.w,
                                    height: 14.h,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () async {},
                            icon: Tooltip(
                              message: 'More',
                              child: Icon(
                                Icons.more_vert_outlined,
                                color: Colors.grey[300],
                                size: 22.0.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                heightSizedBox(12),
              ],
            );
          } else if (state is UpcomingEventsSuccess) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming events',
                      style: Styles.styles18SemiBoldBlack,
                    ),
                    TextButton(
                        onPressed: () {
                          GoRouter.of(context).push(
                              Routes.kSeeAllUpcomingEvents,
                              extra: state.upcomingEvents);
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(color: kPrimaryGreen),
                        )),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.upcomingEvents.length,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return UpcomingEventsListItem(
                      finalPrice: state.upcomingEvents[index].finalPrice ?? 0.0,
                      image: state.upcomingEvents[index].petImage ?? '',
                      serviceName:
                          state.upcomingEvents[index].serviceType ?? '',
                      endDate:
                          state.upcomingEvents[index].endTime ?? DateTime.now(),
                      startDate: state.upcomingEvents[index].startTime ??
                          DateTime.now(),
                      reserveId: state.upcomingEvents[index].reserveId ?? -1,
                    );
                  },
                ),
              ],
            );
          } else if (state is UpcomingEventsFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else {
            return const Text('something went wrong!');
          }
        },
      ),
    );
  }
}

class UpcomingEventsListItem extends StatelessWidget {
  const UpcomingEventsListItem(
      {super.key,
      required this.image,
      required this.serviceName,
      required this.startDate,
      required this.endDate,
      this.finalPrice,
      required this.reserveId});
  final String image;
  final String serviceName;
  final DateTime startDate;
  final DateTime endDate;
  final dynamic finalPrice;
  final int reserveId;
  @override
  Widget build(BuildContext context) {
    // Determine the icon and date format based on the service name
    IconData getIcon() {
      if (serviceName.toLowerCase() == 'boarding') {
        return FontAwesomeIcons.house;
      } else if (serviceName.toLowerCase() == 'walking') {
        return FontAwesomeIcons.shoePrints;
      } else if (serviceName.toLowerCase() == 'grooming') {
        return FontAwesomeIcons.soap;
      }
      return FontAwesomeIcons.couch;
    }

    String getStartDate() {
      if (serviceName.toLowerCase() == 'boarding') {
        return '-From ${DateFormat('EEEE, d MMM, yyyy').format(startDate)}';
      } else if (serviceName.toLowerCase() == 'grooming') {
        return DateFormat('EEEE, d MMM, yyyy').format(startDate);
      } else if (serviceName.toLowerCase() == 'walking') {
        return DateFormat('EEEE, d MMM, yyyy').format(startDate);
      } else if (serviceName.toLowerCase() == 'sitting') {
        return DateFormat('EEEE, d MMM, yyyy').format(startDate);
      } else {
        return '';
      }
    }

    String getEndDate() {
      if (serviceName.toLowerCase() == 'boarding') {
        return '-to ${DateFormat('EEEE, d MMM, yyyy').format(endDate)}';
      } else if (serviceName.toLowerCase() == 'grooming') {
        return '${DateFormat('hh:mma').format(startDate.add(const Duration(hours: 3)))} - ${DateFormat('hh:mma').format(endDate.add(const Duration(hours: 3)))}';
      } else if (serviceName.toLowerCase() == 'walking') {
        return '${DateFormat('hh:mma').format(startDate.add(const Duration(hours: 3)))} - ${DateFormat('hh:mma').format(endDate.add(const Duration(hours: 3)))}';
      } else if (serviceName.toLowerCase() == 'sitting') {
        return '${DateFormat('hh:mma').format(startDate.add(const Duration(hours: 3)))} - ${DateFormat('hh:mma').format(endDate.add(const Duration(hours: 3)))}';
      } else
        // ignore: curly_braces_in_flow_control_structures
        return '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.white,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(10.0.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0.h, horizontal: 14.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26.0.r,
                  backgroundImage:
                      AssetImage('${Constants.profilePictrues}/$image'),
                ),
                widthSizedBox(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      getStartDate(),
                      style: Styles.styles12NormalHalfBlack,
                    ),
                    Text(
                      getEndDate(),
                      style: Styles.styles12NormalHalfBlack,
                    ),
                    heightSizedBox(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          getIcon(),
                          size: 16.sp,
                          color: kPrimaryGreen,
                        ),
                        widthSizedBox(10),
                        Text(
                          'Pet $serviceName',
                          style: Styles.styles14NormalBlack,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                serviceName == 'Walking'
                    ? Column(
                        children: [
                          BlocProvider(
                            create: (context) => StartWalkingRequestCubit(
                                UpcomingWalkingRepoImp(
                                    apiService: ApiService(dio: Dio()))),
                            child: BlocConsumer<StartWalkingRequestCubit,
                                StartWalkingRequestState>(
                              listener: (context, startState) {
                                if (startState is StartWalkingRequestSuccess) {
                                  // context.pushNamed(Routes.KTrackWalk, extra: {
                                  //   'lat': geofenceLatitude,
                                  //   'long': geofenceLongitude,
                                  //   'radius': geofenceRadius,
                                  // });
                                }
                              },
                              builder: (context, state) {
                                return TextButton(
                                    onPressed: () {
                                      BlocProvider.of<StartWalkingRequestCubit>(
                                              context)
                                          .startWalkingRequest(reserveId);
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: kPrimaryGreen,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0.r)),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                            MediaQuery.of(context).size.height *
                                                0.01)),
                                    child: Text(
                                      'Start',
                                      style: Styles.styles16BoldWhite,
                                    ));
                              },
                            ),
                          ),
                          heightSizedBox(6),
                          Text(
                            '$finalPrice/EGP',
                            style: Styles.styles12w600,
                          ),
                        ],
                      )
                    : Text(
                        '$finalPrice/EGP',
                        style: Styles.styles12w600,
                      ),
              ],
            ),
          ),
        ),
        heightSizedBox(12),
      ],
    );
  }
}
