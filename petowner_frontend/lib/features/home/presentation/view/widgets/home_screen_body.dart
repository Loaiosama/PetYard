import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/home/data/repo/home_repo_impl.dart';
// import 'package:petowner_frontend/core/utils/theming/colors.dart';
// import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/see_all.dart';
import 'package:petowner_frontend/features/home/presentation/view_model/Home_providers/home_providers_cubit.dart';
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
                  SeeAllRow(title: 'Top Providers', onPressed: () {}),
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
    return BlocProvider(
      create: (context) =>
          HomeProvidersCubit(HomeRepoImpl(apiService: ApiService(dio: Dio())))
            ..fetchRecommendedProviders(),
      child: BlocBuilder<HomeProvidersCubit, HomeProvidersState>(
        builder: (context, state) {
          if (state is RecommendedProvidersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecommendedProvidersFailure) {
            return Center(child: Text(state.errorMessage));
          } else if (state is RecommendedProvidersSuccess) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => PetCarerCardWidget(
                provider: state.providersList[index],
              ),
              itemCount: min(state.providersList.length, 4),
            );
          } else {
            return const Center(child: Text('No providers found'));
          }
        },
      ),
    );
  }
}
