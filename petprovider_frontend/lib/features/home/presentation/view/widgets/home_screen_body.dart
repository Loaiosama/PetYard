import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/green_container_at_top.dart';
import 'package:petprovider_frontend/features/home/data/models/profile_info/datum.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo_impl.dart';
import 'package:petprovider_frontend/features/home/presentation/view%20model/profile_info_cubit/profile_info_cubit.dart';

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
                          heightSizedBox(16),
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
                    IconButton(
                      onPressed: () {
                        GoRouter.of(context).push(Routes.kAvailableSlotsScreen,
                            extra: services[index].type ?? 'no service name');
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming events',
          style: Styles.styles18SemiBoldBlack,
        ),
        heightSizedBox(12),
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
                ),
                widthSizedBox(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '22.06.2024 | 9:30Am',
                      style: Styles.styles12NormalHalfBlack,
                    ),
                    heightSizedBox(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          FontAwesomeIcons.shoePrints,
                          size: 16.sp,
                          color: kPrimaryGreen,
                        ),
                        widthSizedBox(10),
                        Text(
                          'Pet Walking',
                          style: Styles.styles14NormalBlack,
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
                      color: Colors.black.withOpacity(0.5),
                      size: 22.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        heightSizedBox(12),
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
                ),
                widthSizedBox(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '22.06.2024 | 9:30Am',
                      style: Styles.styles12NormalHalfBlack,
                    ),
                    heightSizedBox(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          FontAwesomeIcons.shoePrints,
                          size: 16.sp,
                          color: kPrimaryGreen,
                        ),
                        widthSizedBox(10),
                        Text(
                          'Pet Walking',
                          style: Styles.styles14NormalBlack,
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
                      color: Colors.black.withOpacity(0.5),
                      size: 22.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        heightSizedBox(12),
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
                ),
                widthSizedBox(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '22.06.2024 | 9:30Am',
                      style: Styles.styles12NormalHalfBlack,
                    ),
                    heightSizedBox(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          FontAwesomeIcons.shoePrints,
                          size: 16.sp,
                          color: kPrimaryGreen,
                        ),
                        widthSizedBox(10),
                        Text(
                          'Pet Walking',
                          style: Styles.styles14NormalBlack,
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
                      color: Colors.black.withOpacity(0.5),
                      size: 22.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
