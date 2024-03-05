import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/signup.dart';
import 'package:petowner_frontend/features/splash/splash_view.dart';

abstract class AppRouter {
  static final GoRouter appRouter = GoRouter(
    routes: [
      GoRoute(
        path: Routes.kSplashScreen,
        builder: (BuildContext context, GoRouterState state) {
          Future.delayed(const Duration(seconds: 3), () {
            appRouter.go(
              Routes.kSignupScreen,
            );
          });
          return const SplashView();
        },
      ),
      GoRoute(
        path: Routes.kSignupScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
        },
      ),
    ],
  );
}
