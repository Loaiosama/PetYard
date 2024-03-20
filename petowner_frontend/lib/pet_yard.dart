import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/routing/app_router.dart';

import 'core/utils/theming/colors.dart';
// import 'package:petowner_frontend/core/utils/theming/colors.dart';

class PetYardApp extends StatelessWidget {
  const PetYardApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // precacheImage(const AssetImage('assets/images/cat4.png'), context);
    // precacheImage(const AssetImage('assets/images/dog1.png'), context);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.black38, // Change the color of the status bar here
    // ));

    return ScreenUtilInit(
      designSize: const Size(360, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.appRouter,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            appBarTheme: const AppBarTheme(
              shadowColor: kPrimaryGreen,
              surfaceTintColor: kPrimaryGreen,
            ),
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStatePropertyAll(
                TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }
}
