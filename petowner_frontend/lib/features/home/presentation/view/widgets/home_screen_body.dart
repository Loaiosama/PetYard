import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/see_all.dart';
import 'home_app_bar.dart';
import 'home_banner.dart';
import 'main_service_widget.dart';
import 'pet_carer_card.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeAppBar(),
            heightSizedBox(24),
            const HomeBanner(),
            heightSizedBox(16),
            const MainServiceWidget(),
            heightSizedBox(16),
            const RecommendedCarer(),
          ],
        ),
      ),
    );
  }
}

class RecommendedCarer extends StatelessWidget {
  const RecommendedCarer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeeAllRow(title: 'Recommendation Carer', onPressed: () {}),
        heightSizedBox(10),
        SizedBox(
          height: 180,
          child: ListView.builder(
            itemBuilder: (context, index) => const PetCarerCardWidget(),
            itemCount: 4,
          ),
        )
      ],
    );
  }
}

