import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/routing/app_router.dart';
import 'package:petowner_frontend/features/pet%20profile/pet_type.dart';

class PetYardApp extends StatelessWidget {
  const PetYardApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
 
    return ScreenUtilInit(
    
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.appRouter,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}
