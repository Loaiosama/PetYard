import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/routing/app_router.dart';

class PetYardApp extends StatelessWidget {
  const PetYardApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(),
    );
  }
}
