import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';

class ReservationFailure extends StatelessWidget {
  const ReservationFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: ReservationFailureBody()),
    );
  }
}

class ReservationFailureBody extends StatelessWidget {
  const ReservationFailureBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.solidCircleXmark,
                color: Colors.red,
                size: 120.sp,
              ),
              heightSizedBox(20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Something went wrong!',
                  style: Styles.styles20MediumBlack,
                ),
              ),
              heightSizedBox(4),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Please try again later.',
                  textAlign: TextAlign.center,
                  style: Styles.styles12NormalHalfBlack,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 30.0.h,
              right: 20.w,
              left: 20.w,
            ),
            child: PetYardTextButton(
              color: Colors.red,
              onPressed: () {
                GoRouter.of(context).push(Routes.kHomeScreen, extra: 0);
              },
              text: 'Done',
              style: Styles.styles16BoldWhite,
            ),
          ),
        )
      ],
    );
  }
}
