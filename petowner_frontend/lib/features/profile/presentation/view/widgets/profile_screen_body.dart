import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/profile/data/model/options_card.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo_impl.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/profile%20cubit/owner_info_cubit.dart';
import 'package:shimmer/shimmer.dart';
import 'active_pet_profile_section.dart';
import 'profile_centered_image.dart';
import 'profile_options_card.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.71,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.0.w, right: 20.0.w, top: 74.0.h),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const OwnerNameAndMail(),
                          heightSizedBox(4),
                          const ActivePetProfileSection(),
                          heightSizedBox(8),
                          Column(
                            children: List.generate(
                              3,
                              (index) => Column(
                                children: [
                                  ProfileOptionsCard(
                                    route: routes[index],
                                    cardColor: cardColors[index],
                                    iconColor: iconColors[index],
                                    label: labels[index],
                                    icon: icons[index],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.71 - 72.0,
          left: MediaQuery.of(context).size.width * 0.5 - 70.0,
          child: const ProfileScreenCenteredImage(),
        ),
      ],
    );
  }
}

class OwnerNameAndMail extends StatelessWidget {
  const OwnerNameAndMail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OwnerInfoCubit(ProfileRepoImpl(apiService: ApiService(dio: Dio())))
            ..getOwnerInfo(),
      child: BlocBuilder<OwnerInfoCubit, OwnerInfoState>(
        builder: (context, state) {
          if (state is OwnerInfoSuccess) {
            return Column(
              children: [
                Text(
                  '${state.ownerInfo.data?.firstName ?? 'no name'} ${state.ownerInfo.data?.lastName ?? 'no name'}',
                  style: Styles.styles20SemiBoldBlack,
                ),
                heightSizedBox(2),
                Text(
                  state.ownerInfo.data?.email ?? 'no email provided',
                  style: Styles.styles12RegularOpacityBlack,
                ),
                heightSizedBox(2),
                Text(
                  state.ownerInfo.data?.phone ?? 'no phone provided',
                  style: Styles.styles12RegularOpacityBlack,
                ),
              ],
            );
          } else if (state is OwnerInfoLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  Container(
                    width: 200.w,
                    height: 24.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    width: 150.w,
                    height: 16.h,
                    color: Colors.white,
                  ),
                ],
              ),
            );
          } else if (state is OwnerInfoFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else {
            return const Text('oops!');
          }
        },
      ),
    );
  }
}
