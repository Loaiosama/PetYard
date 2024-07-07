import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petprovider_frontend/core/constants/constants.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/green_container_at_top.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo_impl.dart';
import 'package:petprovider_frontend/features/home/presentation/view%20model/profile_info_cubit/profile_info_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProfileScreenBody(),
    );
  }
}

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider(
        create: (context) =>
            ProfileInfoCubit(HomeRepoImppl(api: ApiService(dio: Dio())))
              ..fetchProviderInfo(),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            if (state is ProfileInfoSuccess) {
              var info = state.profileInfo.providerinfo?[0];
              return Stack(children: [
                Column(
                  children: [
                    const GreenContainerAtTop(),
                    heightSizedBox(50),
                    Text(
                      info?.username ?? 'no username',
                      style: Styles.styles20SemiBoldBlack,
                    ),
                    heightSizedBox(4),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '0.0',
                                style: Styles.styles14NormalBlack,
                              ),
                              widthSizedBox(6),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '0 Reviews',
                                style: Styles.styles12NormalHalfBlack,
                              ),
                            ],
                          ),
                          heightSizedBox(12),
                          SizedBox(
                            width: double.infinity,
                            child: Material(
                              elevation: 2.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contact',
                                      style: Styles.styles16w600,
                                    ),
                                    heightSizedBox(6),
                                    Text(
                                      'Phone:',
                                      style: Styles.styles14NormalBlack,
                                    ),
                                    Text(
                                      info?.phone ?? 'no phone number',
                                      style: Styles.styles14NormalBlack,
                                    ),
                                    heightSizedBox(6),
                                    Text(
                                      'Email:',
                                      style: Styles.styles14NormalBlack,
                                    ),
                                    Text(
                                      info?.email ?? 'no email',
                                      style: Styles.styles14NormalBlack,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          heightSizedBox(12),
                          SizedBox(
                            width: double.infinity,
                            child: Material(
                              color: Colors.white,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location',
                                      style: Styles.styles16w600,
                                    ),
                                    heightSizedBox(6),
                                    Row(
                                      children: [
                                        Text(
                                          'Street:',
                                          style: Styles.styles14NormalBlack,
                                        ),
                                        widthSizedBox(8),
                                        Text(
                                          'Gza\'er Square',
                                          style: Styles.styles14NormalBlack,
                                        ),
                                      ],
                                    ),
                                    heightSizedBox(6),
                                    Row(
                                      children: [
                                        Text(
                                          'City:',
                                          style: Styles.styles14NormalBlack,
                                        ),
                                        widthSizedBox(8),
                                        Text(
                                          'Maadi',
                                          style: Styles.styles14NormalBlack,
                                        ),
                                      ],
                                    ),
                                    heightSizedBox(6),
                                    Row(
                                      children: [
                                        Text(
                                          'Country:',
                                          style: Styles.styles14NormalBlack,
                                        ),
                                        widthSizedBox(8),
                                        Text(
                                          'Egypt',
                                          style: Styles.styles14NormalBlack,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          heightSizedBox(12),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0.w, horizontal: 16.0.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Settings',
                                    style: Styles.styles16w600,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward_ios,
                                        size: 16.sp),
                                    onPressed: () {
                                      // Handle settings button press
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          heightSizedBox(10),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.70 - 110.0,
                  left: MediaQuery.of(context).size.width * 0.5 - 65.0,
                  child: Container(
                    width: 120.0.w,
                    height: 120.0.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        // color: kSecondaryColor,
                        image: DecorationImage(
                          image: AssetImage('assets/images/image.png'),
                        )),
                  ),
                ),
              ]);
            } else if (state is ProfileInfoLoading) {
              return Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4),
                child: const SafeArea(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryGreen,
                    ),
                  ),
                ),
              );
            } else if (state is ProfileInfoFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return const Center(
                child: Text('SomeThing went wrong!'),
              );
            }
          },
        ),
      ),
    );
  }
}
