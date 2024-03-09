import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/routing/routing_animation.dart';
import 'package:petowner_frontend/features/onboarding/presentation/onboarding_screen.dart';
import 'package:petowner_frontend/features/pet%20profile/pet_type.dart';
import 'package:petowner_frontend/features/registration/signin/presentation/view/signin.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/view/signup.dart';
import 'package:petowner_frontend/features/splash/splash_view.dart';

abstract class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: Routes.kSplashScreen,
    routes: [
      GoRoute(
        path: Routes.kSplashScreen,
        builder: (BuildContext context, GoRouterState state) {
          Future.delayed(const Duration(seconds: 3), () {
            appRouter.go(
              Routes.kOnBoardingScreen,
            );
          });
          return const SplashView();
        },
      ),
      GoRoute(
        path: Routes.kSignupScreen,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SignUpScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.ease).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: Routes.kSigninScreen,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SignInScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.ease).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: Routes.kOnBoardingScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const OnBoardingScreen();
        },
      ),
      GoRoute(
        path: Routes.kChooseType,
        // builder: (BuildContext context, GoRouterState state) {
        //   return const ChooseType();
        // },
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const ChooseType(),
        ),
      ),
    ],
  );
}
