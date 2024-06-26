import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo_impl.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/profile%20cubit/owner_info_cubit.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocProvider(
              create: (context) => OwnerInfoCubit(
                  ProfileRepoImpl(apiService: ApiService(dio: Dio())))
                ..getOwnerInfo(),
              child: BlocBuilder<OwnerInfoCubit, OwnerInfoState>(
                builder: (context, state) {
                  if (state is OwnerInfoSuccess) {
                    return Text(
                      'Hello, ${state.ownerInfo.data?.firstName ?? 'Welcome Back'}!',
                      style: Styles.styles22BoldGreen.copyWith(fontSize: 18.sp),
                    );
                  }
                  return Text(
                    'Hello, Welcome Back!',
                    style: Styles.styles22BoldGreen.copyWith(fontSize: 18.sp),
                  );
                },
              ),
            ),
            Text(
              'How are you today',
              style: Styles.styles12RegularOpacityBlack,
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.11,
          height: MediaQuery.of(context).size.width * 0.11,
          decoration: BoxDecoration(
            // color: Colors.grey[200],
            borderRadius: BorderRadius.circular(18.0.r),
          ),
          child: Center(
            child: IconButton(
              onPressed: () {},
              icon: Tooltip(
                message: 'Notifications',
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.black,
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
