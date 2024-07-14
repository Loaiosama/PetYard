import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/home/data/repo/home_repo_impl.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/pet_carer_card.dart';
import 'package:petowner_frontend/features/home/presentation/view_model/Home_providers/home_providers_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/widgets/search_text_field.dart';

class ServiceProvidersScreen extends StatelessWidget {
  const ServiceProvidersScreen({
    super.key,
    required this.serviceName,
  });
  final String serviceName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18.sp,
            color: Colors.black,
          ),
        ),
        title: Text(
          '$serviceName Providers',
          style: Styles.styles18SemiBoldBlack,
        ),
        centerTitle: true,
      ),
      body: ServiceProvidersBody(
        serviceName: serviceName,
      ),
    );
  }
}

class ServiceProvidersBody extends StatelessWidget {
  const ServiceProvidersBody({super.key, required this.serviceName});
  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeProvidersCubit(HomeRepoImpl(
        apiService: ApiService(
          dio: Dio(),
        ),
      ))
        ..getAllProvidersOfService(serviceName: serviceName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<HomeProvidersCubit, HomeProvidersState>(
            builder: (context, state) {
              return Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: SearchTextField(
                      onChanged: (p0) {
                        context.read<HomeProvidersCubit>().searchProviders(p0);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {},
                    child: Tooltip(
                      message: 'More',
                      child: PopupMenuButton<int>(
                        icon: Icon(
                          FontAwesomeIcons.sort,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        onSelected: (int result) {
                          if (result >= 0) {
                            // Handle rating filter
                            context
                                .read<HomeProvidersCubit>()
                                .fetchProvidersSortedByRating(
                                    rating: result, serviceName: serviceName);
                            // print('Selected rating filter: > $result');
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                          for (int i = 5; i >= 0; i--)
                            PopupMenuItem<int>(
                              value: i,
                              child: Row(
                                children: [
                                  Text('> $i'),
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<HomeProvidersCubit, HomeProvidersState>(
            builder: (context, state) {
              if (state is HomeProvidersLoading ||
                  state is SortedProvidersLoading) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      itemCount: 5,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const BuildShimmerListItem();
                      },
                    ),
                  ),
                );
              } else if (state is HomeProvidersSuccess) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      itemCount: state.providersList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ProviderListItem(
                          image:
                              state.providersList[index].data![0].image ?? '',
                          id: state.providersList[index].data![0].providerId ??
                              -1,
                          serviceName: serviceName,
                          userName:
                              state.providersList[index].data![0].username ??
                                  'no name',
                          rating:
                              state.providersList[index].data![0].rate ?? 0.0,
                          count: state.providersList[index].data![0].count ?? 0,
                        );
                      },
                    ),
                  ),
                );
              } else if (state is SortedProvidersSuccess) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      itemCount: state.providersList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final provider = state.providersList[index];
                        return ProviderListItem(
                          image: provider.image ?? '',
                          id: provider.providerId ?? -1,
                          serviceName: serviceName,
                          userName: provider.username ?? 'no name',
                          rating: provider.averageRating,
                          count: provider.reviewCount,
                        );
                      },
                    ),
                  ),
                );
              } else if (state is HomeProvidersFailure) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 200),
                  child: Center(
                    child: Text(state.errorMessage),
                  ),
                );
              } else if (state is SortedProvidersFailure) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 200),
                  child: Center(
                    child: Text(state.errorMessage),
                  ),
                );
              }
              return const Center(
                child: Text('OOPS'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProviderListItem extends StatelessWidget {
  const ProviderListItem({
    super.key,
    required this.userName,
    required this.id,
    required this.serviceName,
    required this.image,
    this.rating,
    this.count,
  });
  final String userName;
  final int id;
  final String serviceName;
  final String image;
  final num? rating;
  final dynamic count;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              GoRouter.of(context).pushNamed(
                Routes.kProviderProfile,
                extra: {
                  'id': id,
                  'serviceName': serviceName,
                },
              );
              // context
              //     .pushNamed(Routes.kProviderProfile, extra: {id, serviceName});
            },
            child: Material(
              color: Colors.white,
              elevation: 1.0,
              borderRadius: BorderRadius.circular(10.0.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120.h,
                    width: 110.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0.r),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            // 'assets/images/1.png',
                            '${Constants.profilePictures}/$image'),
                      ),
                    ),
                  ),
                  widthSizedBox(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: Styles.styles16w600,
                      ),
                      heightSizedBox(4),
                      Text(
                        'Pet $serviceName',
                        style: Styles.styles12NormalHalfBlack,
                      ),
                      heightSizedBox(4),
                      RatingRowWidget(
                        rating: rating!.toDouble(),
                        count: count,
                      )

                      // RatingRowWidget(
                      //   rating: rating,
                      //   count: count,
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildShimmerListItem extends StatelessWidget {
  const BuildShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Column(
          children: [
            Material(
              color: Colors.white,
              elevation: 1.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120.h,
                    width: 110.w,
                    color: Colors.white,
                  ),
                  widthSizedBox(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        3,
                        (index) => Container(
                          height: 16.0,
                          width: MediaQuery.of(context).size.width * 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
