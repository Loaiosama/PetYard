import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/utils/routing/app_router.dart';
import 'core/utils/theming/colors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black38, // status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.appRouter,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // fontFamily: 'Inter',
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
