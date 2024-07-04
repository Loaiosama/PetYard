import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void signOut(BuildContext context) async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    // ignore: use_build_context_synchronously
    GoRouter.of(context).go(Routes.kSigninScreen);
  }

  void resetPassword(BuildContext context) {
    // Add your reset password logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset password clicked')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.sp),
        ),
        title: Text(
          'Settings',
          style: Styles.styles18SemiBoldBlack,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red, size: 24.sp),
              title: Text(
                'Log Out',
                style: Styles.styles16w600,
              ),
              onTap: () => signOut(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock_reset, color: Colors.blue, size: 24.sp),
              title: Text(
                'Reset Password',
                style: Styles.styles16w600,
              ),
              onTap: () => resetPassword(context),
            ),
          ],
        ),
      ),
    );
  }
}
