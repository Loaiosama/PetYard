import 'package:dio/dio.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo_impl.dart';

import 'widgets/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static ProfileRepoImpl profileRepoImpl =
      ProfileRepoImpl(apiService: ApiService(dio: Dio()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          'Profile',
          style: Styles.styles18MediumWhite,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push(Routes.kSettings);
            },
            icon: Tooltip(
              message: 'Settings',
              child: Icon(
                FluentIcons.settings_32_regular,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
          widthSizedBox(4),
        ],
      ),
      backgroundColor: kPrimaryGreen,
      body: const ProfileScreenBody(),
    );
  }
}
