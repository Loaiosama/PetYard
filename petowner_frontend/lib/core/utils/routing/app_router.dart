import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/features/onboarding/presentation/onboarding_screen.dart';
import 'package:petowner_frontend/features/pet%20profile/pet_type.dart';
import 'package:petowner_frontend/features/registration/signin/presentation/signin.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/signup.dart';
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
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
        },
        // pageBuilder: (context, state) {
        //   return CustomTransitionPage(
        //     key: state.pageKey,
        //     child: const SignUpScreen(),
        //     transitionsBuilder:
        //         (context, animation, secondaryAnimation, child) {
        //       // Change the opacity of the screen using a Curve based on the the animation's
        //       // value
        //       return FadeTransition(
        //         opacity: CurveTween(curve: Curves.ease).animate(animation),
        //         child: child,
        //       );
        //     },
        //   );
        // },
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
        // builder: (BuildContext context, GoRouterState state) {
        //   return const SignInScreen();
        // },
      ),
      GoRoute(
        path: Routes.kOnBoardingScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const OnBoardingScreen();
        },
      ),
      GoRoute(
        path: Routes.kChooseType,
        builder: (BuildContext context, GoRouterState state) {
          return const ChooseType();
        },
      ),
    ],
  );
}
