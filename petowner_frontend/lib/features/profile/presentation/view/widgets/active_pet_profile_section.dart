import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
// import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/fonts_helper.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/profile/data/repo/get_all_pets_repo.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/active_pets_cubit/active_pets_cubit_cubit.dart';

import 'pet_profile_circle.dart';

class ActivePetProfileSection extends StatelessWidget {
  const ActivePetProfileSection({super.key});

  static ProfileRepoImpl activePetRepo =
      ProfileRepoImpl(apiService: ApiService(dio: Dio()));

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
                  // const Divider(),
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
                                // activePetRepo.getAllPets();
                                // GoRouter.of(context).push(Routes.kPetInformation);
                              },
                              child: PetProfileCircle(
                                petName: state.allPets[index].data![0].name ??
                                    'no name',
                                petImage:
                                    state.allPets[index].data![0].image ?? '',
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
              return const CircularProgressIndicator();
            } else if (state is ActivePetsCubitFailure) {
              return Text(state.errorMessage);
            }
            return const Text('hmmmm');
          },
        ));
  }
}
