import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/provider%20profile/presentation/view/widgets/provider_profile_card.dart';
import 'package:petowner_frontend/features/reserve%20service/presentation/view/widgets/summary_tab.dart';

class ReservationSuccess extends StatelessWidget {
  const ReservationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: ReservationSuccessBody()),
    );
  }
}

class ReservationSuccessBody extends StatelessWidget {
  const ReservationSuccessBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 90.h, right: 20.w, left: 20.w, bottom: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/svgs/circle-check-solid.svg',
              height: 100.h,
              width: 100.w,
              colorFilter:
                  const ColorFilter.mode(kPrimaryGreen, BlendMode.srcIn),
            ),
          ),
          heightSizedBox(20),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Booking Confirmed.',
              style: Styles.styles20MediumBlack,
            ),
          ),
          heightSizedBox(4),
          Align(
            alignment: Alignment.center,
            child: Text(
              'We will contact you soon to let you know whether mohamed accepted your request or not.',
              textAlign: TextAlign.center,
              style: Styles.styles12NormalHalfBlack,
            ),
          ),
          heightSizedBox(40),
          Text(
            'Booking Information',
            style: Styles.styles14w600,
          ),
          heightSizedBox(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SummaryIconContainer(
                containerColor: Color.fromRGBO(234, 242, 255, 1),
                iconColor: Color.fromRGBO(36, 124, 255, 1),
                icon: FontAwesomeIcons.solidCalendar,
              ),
              widthSizedBox(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date & Time',
                    style: Styles.styles12w600,
                  ),
                  heightSizedBox(2),
                  Text(
                    // '-From Wednesday, 08 May 2023',
                    '-From sunday, 20 may 2034',
                    style: Styles.styles12NormalHalfBlack,
                  ),
                  Text(
                    '-To sunday, 20 may 2034',
                    style: Styles.styles12NormalHalfBlack,
                  ),
                ],
              ),
            ],
          ),
          heightSizedBox(6),
          const Divider(),
          heightSizedBox(6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SummaryIconContainer(
                containerColor: Color.fromRGBO(233, 250, 239, 1),
                iconColor: Color.fromRGBO(34, 197, 94, 1),
                icon: Iconsax.clipboard_text4,
              ),
              widthSizedBox(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service',
                    style: Styles.styles12w600,
                  ),
                  heightSizedBox(2),
                  Text(
                    'Pet Boarding',
                    style: Styles.styles12NormalHalfBlack,
                  ),
                ],
              ),
            ],
          ),
          heightSizedBox(6),
          const Divider(),
          heightSizedBox(6),
          heightSizedBox(6),
          Text(
            'Pet Carer Information',
            style: Styles.styles14w600,
          ),
          heightSizedBox(10),
          const ProviderProfileCard(
            providerName: 'providerName',
          ),
          const Spacer(),
          PetYardTextButton(
            onPressed: () {
              GoRouter.of(context).push(Routes.kHomeScreen, extra: 0);
            },
            text: 'Done',
            style: Styles.styles16BoldWhite,
          ),
        ],
      ),
    );
  }
}
