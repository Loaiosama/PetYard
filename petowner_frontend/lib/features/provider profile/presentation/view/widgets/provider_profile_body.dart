import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'about_tab.dart';
import 'location_tab.dart';
import 'provider_profile_card.dart';
import 'review_tab.dart';

class ProviderProfileBody extends StatelessWidget {
  const ProviderProfileBody(
      {super.key, required this.id, required this.serviceName});
  final int id;
  final String serviceName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, top: 16.0.h),
      child: Column(
        children: [
          const ProviderProfileCard(),
          heightSizedBox(24),
          Padding(
            padding: EdgeInsets.only(right: 12.0.w),
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    // controller: tabController,
                    labelStyle:
                        Styles.styles14w600.copyWith(color: kPrimaryGreen),
                    unselectedLabelStyle: Styles.styles12RegularOpacityBlack
                        .copyWith(fontSize: 14.sp),
                    indicatorColor: kPrimaryGreen,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.only(bottom: 4.0.h),
                    physics: const BouncingScrollPhysics(),
                    tabs: const [
                      Text('About'),
                      Text('Location'),
                      Text('Reviews'),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.59,
                    child: TabBarView(
                      // controller: tabController,
                      children: [
                        AboutTabColumn(
                          serviceName: serviceName,
                        ),
                        const LocationTabColumn(),
                        const ReviewsTabColumn(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const MakeAppointmentButtonsRow(),
        ],
      ),
    );
  }
}

class MakeAppointmentButtonsRow extends StatelessWidget {
  const MakeAppointmentButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0.w, top: 20.0.h),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0.w),
              child: PetYardTextButton(
                onPressed: () {
                  GoRouter.of(context).push(Routes.kbookAppointment);
                },
                text: 'Make An Appointment',
                style: Styles.styles14w600.copyWith(
                  color: Colors.white,
                ),
                // color: kBlue,
                height: 54.0.h,
                // width: MediaQuery.of(context).size.width * 0.73,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 54.h,
              // width: MediaQuery.of(context).size.width * 0.14,
              decoration: BoxDecoration(
                color: kPrimaryGreen,
                borderRadius: BorderRadius.circular(10.0.r),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Tooltip(
                  message: 'Send a message to Olivia.',
                  child: Icon(
                    FluentIcons.chat_20_regular,
                    color: Colors.white,
                    size: 28.0.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
