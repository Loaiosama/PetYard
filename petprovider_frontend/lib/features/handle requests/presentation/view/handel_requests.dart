import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view/widgets/boarding_tab.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view/widgets/sitting_tab.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view/widgets/walking_tab.dart';
import 'package:petprovider_frontend/features/home/data/models/profile_info/datum.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo_impl.dart';
import 'package:petprovider_frontend/features/home/presentation/view%20model/profile_info_cubit/profile_info_cubit.dart';

class Jobs extends StatelessWidget {
  const Jobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: 70.0.h),
          child: SizedBox(child: ServiceTabBar())),
    );
  }
}

class ServiceTabBar extends StatelessWidget {
  const ServiceTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            ProfileInfoCubit(HomeRepoImppl(api: ApiService(dio: Dio())))
              ..fetchProviderInfo(),
        child: Column(
          children: [
            Center(
              child: Text("Jobs", style: Styles.styles18AppBarBlack),
            ),
            SizedBox(
              height: 30.h,
            ),
            BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
                builder: (context, state) {
              if (state is ProfileInfoLoading) {
                return const CircularProgressIndicator();
              } else if (state is ProfileInfoSuccess) {
                return createTabBar(state.profileInfo.data ?? [], context);
              } else if (state is ProfileInfoFailure) {
                return const Text("There is no service");
              } else {
                return const SizedBox();
              }
            }),
          ],
        ));
  }
}

Widget createTabBar(List<Datum> services, BuildContext context) {
  return DefaultTabController(
    length: services.length,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (value) {},
            dividerHeight: 0,
            indicator: BoxDecoration(
              color:
                  kPrimaryGreen, // Set the background color of the selected tab indicator
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: Colors.white, // Text color of the selected tab label
            unselectedLabelColor: Colors.black,
            isScrollable: true,
            tabs: services
                .map((service) => Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              service.type ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          height: 500.0.h,
          child: TabBarView(
            children: services.map((service) {
              if (service.type == "Sitting") {
                return const SittingTab(); // Use SittingTab for "Sitting" tab
              } else if (service.type == "Boarding") {
                return const BoardingTab(); // Use BoardingTab for "Boarding" tab
              } else if (service.type == "Walking") {
                return const WalkingTab();
              } else {
                return Center(
                  child: Text(service.type ?? 'Unknown'),
                ); // Default widget for other tabs
              }
            }).toList(),
          ),
        ),
      ],
    ),
  );
}
