import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/provider%20profile/data/models/provider_info_model/data.dart';
import 'about_tab.dart';
import 'location_tab.dart';
import 'provider_profile_card.dart';
import 'review_tab.dart';

class ProviderProfileBody extends StatelessWidget {
  const ProviderProfileBody({
    super.key,
    required this.id,
    required this.serviceName,
    required this.bio,
    required this.email,
    required this.phoneNumber,
    required this.userName,
    required this.age,
    required this.services,
    required this.image,
    required this.rating,
    required this.count,
  });
  final int id;
  final String serviceName;
  final String bio;
  final String email;
  final int age;
  final String phoneNumber;
  final String userName;
  final List<Service> services;
  final String image;
  final num rating;
  final dynamic count;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, top: 16.0.h),
      child: Column(
        children: [
          ProviderProfileCard(
            services: services,
            providerName: userName,
            image: image,
            rating: rating,
            count: count,
          ),
          heightSizedBox(20),
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
                          services: services,
                          age: age,
                          serviceName: serviceName,
                          bio: bio,
                          email: email,
                          phoneNumber: phoneNumber,
                          userName: userName,
                        ),
                        const LocationTabColumn(),
                        ReviewsTabColumn(
                          providerId: id,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          MakeAppointmentButtonsRow(
            serviceName: serviceName,
            services: services,
            id: id,
            providerName: userName,
          ),
        ],
      ),
    );
  }
}

class MakeAppointmentButtonsRow extends StatelessWidget {
  const MakeAppointmentButtonsRow(
      {super.key,
      required this.serviceName,
      required this.id,
      required this.providerName,
      required this.services});
  final String serviceName;
  final int id;
  final String providerName;
  final List<Service> services;
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
                  if (serviceName == 'Boarding') {
                    GoRouter.of(context).push(
                      Routes.kbookAppointment,
                      extra: {
                        'serviceName': serviceName,
                        'providerId': id,
                        'providerName': providerName,
                        'services': services,
                      },
                    );
                  } else if (serviceName == 'Grooming') {
                    GoRouter.of(context).push(
                      Routes.kgroomingHome,
                      extra: {
                        'serviceName': serviceName,
                        'providerId': id,
                        'providerName': providerName,
                        'services': services,
                      },
                    );
                  }
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
                  message: 'Send a message to $providerName.',
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
