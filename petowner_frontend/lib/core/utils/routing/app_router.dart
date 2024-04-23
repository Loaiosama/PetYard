import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/routing/routing_animation.dart';
import 'package:petowner_frontend/features/home/presentation/view/home.dart';
import 'package:petowner_frontend/features/onboarding/onboarding_screen2.dart';
import 'package:petowner_frontend/features/pet%20profile/data/pet_model.dart';
// import 'package:petowner_frontend/features/onboarding/presentation/onboarding_screen.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/pet_breed.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/pet_info.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/pet_type.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/recap.dart';
import 'package:petowner_frontend/features/profile/presentation/view/location_screen.dart';
import 'package:petowner_frontend/features/profile/presentation/view/personal_information.dart';
import 'package:petowner_frontend/features/profile/presentation/view/pet_information.dart';
import 'package:petowner_frontend/features/provider%20profile/presentation/view/provider_profile_screen.dart';
import 'package:petowner_frontend/features/registration/signin/presentation/view/forgot_password.dart';
import 'package:petowner_frontend/features/registration/signin/presentation/view/signin.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/view/signup.dart';
import 'package:petowner_frontend/features/reserve%20service/presentation/view/reserve_appointment_screen.dart';
import 'package:petowner_frontend/features/splash/splash_view.dart';

abstract class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: Routes.kSplashScreen,
    routes: [
      GoRoute(
        path: Routes.kSplashScreen,
        builder: (BuildContext context, GoRouterState state) {
          Future.delayed(
            const Duration(seconds: 3),
            () {
              appRouter.go(
                Routes.kOnBoardingScreen,
              );
            },
          );
          return const SplashView();
        },
      ),
      // Navigate to sign up screen
      GoRoute(
        path: Routes.kSignupScreen,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const SignUpScreen(),
        ),
      ),
      // Navigate to sign in screen
      GoRoute(
        path: Routes.kSigninScreen,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const SignInScreen(),
        ),
      ),
      // Navigate to home screen
      GoRoute(
        path: Routes.kHomeScreen,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const HomeScreen(),
        ),
      ),
      // Navigate to forget password screen
      GoRoute(
        path: Routes.kForgotPasswordScreen,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      // GoRoute(
      //   path: Routes.kOnBoardingScreen,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const OnBoardingScreen();
      //   },
      // ),
      // Navigate to onboarding screen
      GoRoute(
        path: Routes.kOnBoardingScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const OnBoardingScreen2();
        },
      ),
      // Navigate to choose type of pet screen
      GoRoute(
        path: Routes.kChooseType,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const ChooseType(),
        ),
      ),
      // Navigate to chosse breed of pet screen
      GoRoute(
          name: Routes.kPetBreed,
          path: Routes.kPetBreed,
          pageBuilder: (context, state) {
            final PetModel pet = state.extra as PetModel;
            return transitionGoRoute(
              context: context,
              state: state,
              child: PetBreedScreen(petModel: pet),
            );
          }),
      // Navigate to personal information screen
      GoRoute(
        path: Routes.kPersonalInformation,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const PersonalInformationScreen(),
        ),
      ),
      // Navigate to provider profile screen
      GoRoute(
        path: Routes.kProviderProfile,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const ProviderProfileScreen(),
        ),
      ),
      GoRoute(
          name: Routes.kPetInformation,
          path: Routes.kPetInformation,
          pageBuilder: (context, state) {
            final int id = state.extra as int;
            return transitionGoRoute(
              context: context,
              state: state,
              child: PetInformationScreen(
                id: id,
              ),
            );
          }),
      GoRoute(
        path: Routes.kProfileLocation,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const ProfileLocationScreen(),
        ),
      ),
      GoRoute(
        path: Routes.kbookAppointment,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const BookAppointment(),
        ),
      ),
      GoRoute(
        name: Routes.kAddPetInfo,
        path: Routes.kAddPetInfo,
        pageBuilder: (context, state) {
          //final Object? breed = state.extra;
          final PetModel pet = state.extra as PetModel;
          return transitionGoRoute(
            context: context,
            state: state,
            child: PetInfo(
              petModel: pet,
            ),
          );
        },
      ),
      GoRoute(
        name: Routes.kPetRecap,
        path: Routes.kPetRecap,
        pageBuilder: (context, state) {
          final PetModel pet = state.extra as PetModel;
          return transitionGoRoute(
            context: context,
            state: state,
            child: Recap(petModel: pet),
          );
        },
      ),
    ],
  );
}
