import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/green_container_at_top.dart';
import 'package:petprovider_frontend/features/grooming/data/repo/grooming_repo_impl.dart';
import 'package:petprovider_frontend/features/grooming/presentation/view/grooming_edit_types.dart';
import 'package:petprovider_frontend/features/grooming/presentation/view/grooming_set_slot.dart';
import 'package:petprovider_frontend/features/grooming/presentation/view/grooming_slots_tab.dart';
import 'package:petprovider_frontend/features/grooming/presentation/view_model/edit_types_cubit/edit.types.dart';

import 'boading_set_slot_tab.dart';
import 'boarding_slots_tab.dart';

class AvaialableSlotsScreen extends StatelessWidget {
  const AvaialableSlotsScreen(
      {super.key, required this.serviceName, required this.groomingTypes});
  final String serviceName;
  final List<dynamic> groomingTypes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GreenContainerAtTop(
              subTitle: 'Observe your $serviceName slots and set new ones.',
              subTitleStyle: Styles.styles16BoldWhite,
              isBack: true,
            ),
            DefaultTabController(
              length: serviceName == 'Grooming' ? 3 : 2,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 24.0.h, right: 16.0.w, left: 16.0.w),
                child: Column(
                  children: [
                    TabBar(
                      // controller: tabController,
                      labelStyle: Styles.styles14NormalBlack
                          .copyWith(color: kPrimaryGreen),
                      unselectedLabelStyle: Styles.styles12NormalHalfBlack
                          .copyWith(fontSize: 14.sp),
                      indicatorColor: kPrimaryGreen,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: EdgeInsets.only(bottom: 4.0.h),
                      physics: const BouncingScrollPhysics(),
                      tabs: [
                        if (serviceName == 'Boarding') const Text('Set Slot'),
                        if (serviceName == 'Boarding') const Text('Slots'),
                        if (serviceName == 'Grooming') const Text('Set Slots'),
                        if (serviceName == 'Grooming') const Text('Slots'),
                        if (serviceName == 'Grooming') const Text('Edit Types'),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: double.infinity,
                      child: TabBarView(children: [
                        if (serviceName == 'Boarding')
                          const BoardingSetSlotTab(),
                        // serviceName == 'Boarding'
                        //     ? const BoardingSetSlotTab()
                        //     : Container(),
                        if (serviceName == 'Boarding') const BoardingSlotsTab(),
                        if (serviceName == 'Grooming')
                          const GroomingSetSlotsTab(),
                        if (serviceName == 'Grooming') const GroomingSlotsTab(),
                        if (serviceName == 'Grooming')
                          BlocProvider(
                            create: (context) => GroomingTypesCubit(
                                GroomingRepoImpl(api: ApiService(dio: Dio())))
                              ..initialize(groomingTypes),
                            child: EditGroomingTypesTab(
                              initialTypes: groomingTypes,
                            ),
                          ),
                      ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
