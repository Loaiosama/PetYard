import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/fonts_helper.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo_impl.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/active_pets_cubit/active_pets_cubit_cubit.dart';
import 'package:shimmer/shimmer.dart';

import 'pet_profile_circle.dart';

class ActivePetProfileSection extends StatelessWidget {
  const ActivePetProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ActivePetsCubitCubit(
            ProfileRepoImpl(apiService: ApiService(dio: Dio())))
          ..getAllPets(),
        child: BlocBuilder<ActivePetsCubitCubit, ActivePetsCubitState>(
          builder: (context, state) {
            if (state is ActivePetsCubitSuccess) {
              final petsLength = state.allPets.length;
              return Column(
                children: [
                  heightSizedBox(16),
                  RichText(
                    text: TextSpan(
                      text: 'Your Pets ',
                      style: Styles.styles18SemiBoldBlack.copyWith(
                          letterSpacing: 1.0,
                          fontSize: 16.sp,
                          fontWeight: FontsHelper.regular),
                      children: [
                        TextSpan(
                          text: '$petsLength',
                          style: Styles.styles22BoldGreen
                              .copyWith(fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                  heightSizedBox(8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: List.generate(
                            petsLength,
                            (index) => InkWell(
                              onTap: () {
                                context.pushNamed(Routes.kPetInformation,
                                    extra: state.allPets[index].data![0].petId);
                              },
                              child: PetProfileCircle(
                                petName: state.allPets[index].data![0].name ??
                                    'no name',
                                petImage: state.allPets[index].data![0].image ??
                                    'default.png',
                              ),
                            ),
                          ),
                        ),
                        const PetProfileCircle(
                          isAddNew: true,
                          petName: '',
                          petImage: '',
                        ),
                      ],
                    ),
                  ),
                  heightSizedBox(16),
                  // const Divider(),
                ],
              );
            } else if (state is ActivePetsCubitLoading) {
              return const BuildLoadingShimmer();
            } else if (state is ActivePetsCubitFailure) {
              return Text(state.errorMessage);
            }
            return const Text('hmmmm');
          },
        ));
  }
}

class BuildLoadingShimmer extends StatelessWidget {
  const BuildLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        heightSizedBox(16),
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            height: 20.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0.r),
            ),
          ),
        ),
        heightSizedBox(8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3, // Number of shimmer placeholders
              (index) => _buildShimmerCircle(),
            ),
          ),
        ),
        heightSizedBox(16),
      ],
    );
  }
}

Widget _buildShimmerCircle() {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        heightSizedBox(3),
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 40.0,
            height: 10.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
