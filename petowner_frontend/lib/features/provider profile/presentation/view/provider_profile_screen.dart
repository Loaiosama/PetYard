// import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
// import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/provider%20profile/data/repos/provider_info_repo.dart';
import 'package:petowner_frontend/features/provider%20profile/presentation/view%20model/cubit/provider_info_cubit.dart';
// import 'package:petowner_frontend/features/provider%20profile/data/repos/provider_info_repo.dart';
import 'package:petowner_frontend/features/provider%20profile/presentation/view/widgets/provider_profile_body.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key, required this.id});
  final int id;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProviderInfoCubit(
          ProviderInfoRepo(apiService: ApiService(dio: Dio()))),
      child: BlocBuilder<ProviderInfoCubit, ProviderInfoState>(
        builder: (context, state) {
          if (state is ProviderInfoSuccess) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  state.providerInfoModel.data!.username ?? 'no name',
                  style: Styles.styles18SemiBoldBlack,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 18.0.sp,
                  ),
                ),
                actions: [
                  Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(right: 10.0.w),
                    decoration: BoxDecoration(
                      // shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                        style: BorderStyle.solid,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          // ProviderInfoRepo(apiService: ApiService(dio: Dio()))
                          //     .getProviderInfo(id: id);
                        },
                        icon: Tooltip(
                          message: 'More',
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.black,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              body: ProviderProfileBody(
                id: id,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'no name',
                style: Styles.styles18SemiBoldBlack,
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 18.0.sp,
                ),
              ),
              actions: [
                Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(right: 10.0.w),
                  decoration: BoxDecoration(
                    // shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black.withOpacity(0.2),
                      style: BorderStyle.solid,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        // ProviderInfoRepo(apiService: ApiService(dio: Dio()))
                        //     .getProviderInfo(id: id);
                      },
                      icon: Tooltip(
                        message: 'More',
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: ProviderProfileBody(
              id: id,
            ),
          );
        },
      ),
    );
  }
}
