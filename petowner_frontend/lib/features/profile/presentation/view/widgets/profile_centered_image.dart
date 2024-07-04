import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
// import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo_impl.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/profile%20cubit/owner_info_cubit.dart';

class ProfileScreenCenteredImage extends StatelessWidget {
  const ProfileScreenCenteredImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OwnerInfoCubit(ProfileRepoImpl(apiService: ApiService(dio: Dio())))
            ..getOwnerInfo(),
      child: BlocBuilder<OwnerInfoCubit, OwnerInfoState>(
        builder: (context, state) {
          return Container(
            width: 120.0.w,
            height: 120.0.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                // image: AssetImage('assets/images/profile_pictures/default.png'),
                image: (state is OwnerInfoSuccess)
                    ? AssetImage(
                        'assets/images/profile_pictures/${state.ownerInfo.data!.image}')
                    : const AssetImage('assets/images/default.png'),

                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: Colors.white,
                width: 4.0.w,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 34.w,
                height: 34.h,
                margin: EdgeInsets.only(top: 40.0.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 4.0.w,
                  ),
                  shape: BoxShape.circle,
                  color: const Color.fromRGBO(248, 248, 248, 1),
                ),
                child: IconButton(
                  onPressed: () {
                    GoRouter.of(context).push(
                      Routes.kPersonalInformation,
                    );
                  },
                  icon: Center(
                    child: Icon(
                      FontAwesomeIcons.penToSquare,
                      size: 13.sp,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
