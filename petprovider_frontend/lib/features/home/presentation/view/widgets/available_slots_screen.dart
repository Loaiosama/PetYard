import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/green_container_at_top.dart';

import 'boading_set_slot_tab.dart';
import 'boarding_slots_tab.dart';

class AvaialableSlotsScreen extends StatelessWidget {
  const AvaialableSlotsScreen({super.key, required this.serviceName});
  final String serviceName;
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
              length: 2,
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
                      tabs: const [
                        Text('Set Slot'),
                        Text('Slots'),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: double.infinity,
                      child: TabBarView(children: [
                        serviceName == 'Boarding'
                            ? const BoardingSetSlotTab()
                            : Container(),
                        serviceName == 'Boarding'
                            ? const BoardingSlotsTab()
                            : Container(),
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
