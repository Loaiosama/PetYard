import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
// import 'package:petowner_frontend/core/utils/theming/colors.dart';
// import 'package:petowner_frontend/core/utils/theming/styles.dart';
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeAppBar(),
                  heightSizedBox(24),
                  const HomeBanner(),
                  heightSizedBox(16),
                  const DiscoverServiceWidget(),
                  heightSizedBox(16),
                  SeeAllRow(title: 'Recommended Provider', onPressed: () {}),
                  heightSizedBox(10),
                ],
              ),
            ),
            const SliverFillRemaining(
              child: RecommendedCarerListView(),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendedCarerListView extends StatelessWidget {
  const RecommendedCarerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => const PetCarerCardWidget(),
      itemCount: 10,
    );
  }
}
