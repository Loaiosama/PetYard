import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/routing/routing_animation.dart';
import 'package:petprovider_frontend/features/home/presentation/view/home.dart';
import 'package:petprovider_frontend/features/home/presentation/view/widgets/available_slots_screen.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/choose_service.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/fill_information.dart';

import '../../../features/registration/signin/presentation/view/signin.dart';
import '../../../features/registration/signup/presentation/view/signup.dart';

abstract class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: Routes.kSignupScreen,
    routes: [
      // GoRoute(
      //   path: Routes.kSplashScreen,
      //   builder: (BuildContext context, GoRouterState state) {
      //     Future.delayed(
      //       const Duration(seconds: 3),
      //       () {
      //         appRouter.go(
      //           Routes.kOnBoardingScreen,
      //         );
      //       },
      //     );
      //     return const SplashView();
      //   },
      // ),
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
      GoRoute(
          name: Routes.kFillInformation,
          path: Routes.kFillInformation,
          pageBuilder: (context, state) {
            final Map<String, dynamic> extras =
                state.extra as Map<String, dynamic>;
            final String userName = extras['userName'] as String;
            final String email = extras['email'] as String;
            final String password = extras['password'] as String;
            return transitionGoRoute(
              context: context,
              state: state,
              child: FillInformationSignUp(
                email: email,
                password: password,
                userName: userName,
              ),
            );
          }),
      GoRoute(
        path: Routes.kChooseService,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const ChooseService(),
        ),
      ),
      // Navigate to home screen
      GoRoute(
          name: Routes.kHomeScreen,
          path: Routes.kHomeScreen,
          pageBuilder: (context, state) {
            final int index = state.extra as int;

            return transitionGoRoute(
              context: context,
              state: state,
              child: HomeScreen(
                initialIndex: index,
              ),
            );
          }),
      GoRoute(
          name: Routes.kAvailableSlotsScreen,
          path: Routes.kAvailableSlotsScreen,
          pageBuilder: (context, state) {
            final String serviceName = state.extra as String;
            return transitionGoRoute(
              context: context,
              state: state,
              child: AvaialableSlotsScreen(
                serviceName: serviceName,
              ),
            );
          }),
      // // Navigate to forget password screen
      // GoRoute(
      //   path: Routes.kForgotPasswordScreen,
      //   pageBuilder: (context, state) => transitionGoRoute(
      //     context: context,
      //     state: state,
      //     child: const ForgotPasswordScreen(),
      //   ),
      // ),
      // GoRoute(
      //   path: Routes.kProfileScreen,
      //   pageBuilder: (context, state) => transitionGoRoute(
      //     context: context,
      //     state: state,
      //     child: const ProfileScreen(),
      //   ),
      // ),
      // GoRoute(
      //   path: Routes.kOnBoardingScreen,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const OnBoardingScreen();
      //   },
      // ),
      // Navigate to onboarding screen
      // GoRoute(
      //   path: Routes.kOnBoardingScreen,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const OnBoardingScreen2();
      //   },
      // ),
      // // Navigate to choose type of pet screen
      // GoRoute(
      //   path: Routes.kChooseType,
      //   pageBuilder: (context, state) => transitionGoRoute(
      //     context: context,
      //     state: state,
      //     child: const ChooseType(),
      //   ),
      // ),
      // // Navigate to chosse breed of pet screen
      // GoRoute(
      //     name: Routes.kPetBreed,
      //     path: Routes.kPetBreed,
      //     pageBuilder: (context, state) {
      //       final PetModel pet = state.extra as PetModel;
      //       return transitionGoRoute(
      //         context: context,
      //         state: state,
      //         child: PetBreedScreen(petModel: pet),
      //       );
      //     }),
      // // Navigate to personal information screen
      // GoRoute(
      //   path: Routes.kPersonalInformation,
      //   pageBuilder: (context, state) => transitionGoRoute(
      //     context: context,
      //     state: state,
      //     child: const PersonalInformationScreen(),
      //   ),
      // ),
      // // Navigate to provider profile screen
      // GoRoute(
      //     name: Routes.kProviderProfile,
      //     path: Routes.kProviderProfile,
      //     pageBuilder: (context, state) {
      //       final Map<String, dynamic> extras =
      //           state.extra as Map<String, dynamic>;
      //       final int id = extras['id'] as int;
      //       final String serviceName = extras['serviceName'] as String;
      //       return transitionGoRoute(
      //         context: context,
      //         state: state,
      //         child: ProviderProfileScreen(
      //           id: id,
      //           serviceName: serviceName,
      //         ),
      //       );
      //     }),
      // GoRoute(
      //     name: Routes.kPetInformation,
      //     path: Routes.kPetInformation,
      //     pageBuilder: (context, state) {
      //       final int id = state.extra as int;
      //       return transitionGoRoute(
      //         context: context,
      //         state: state,
      //         child: PetInformationScreen(
      //           id: id,
      //         ),
      //       );
      //     }),
      // GoRoute(
      //   path: Routes.kProfileLocation,
      //   pageBuilder: (context, state) => transitionGoRoute(
      //     context: context,
      //     state: state,
      //     child: const ProfileLocationScreen(),
      //   ),
      // ),
      // GoRoute(
      //   name: Routes.kbookAppointment,
      //   path: Routes.kbookAppointment,
      //   pageBuilder: (context, state) {
      //     final Map<String, dynamic> extras =
      //         state.extra as Map<String, dynamic>;
      //     final int providerId = extras['providerId'] as int;
      //     final String serviceName = extras['serviceName'] as String;
      //     final String providerName = extras['providerName'] as String;
      //     final List<Service> services = extras['services'] as List<Service>;
      //     return transitionGoRoute(
      //       context: context,
      //       state: state,
      //       child: BookAppointment(
      //         services: services,
      //         serviceName: serviceName,
      //         providerId: providerId,
      //         providerName: providerName,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: Routes.kServiceProviders,
      //   path: Routes.kServiceProviders,
      //   pageBuilder: (context, state) {
      //     final String service = state.extra as String;
      //     return transitionGoRoute(
      //       context: context,
      //       state: state,
      //       child: ServiceProvidersScreen(
      //         serviceName: service,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: Routes.kAddPetInfo,
      //   path: Routes.kAddPetInfo,
      //   pageBuilder: (context, state) {
      //     //final Object? breed = state.extra;
      //     final PetModel pet = state.extra as PetModel;
      //     return transitionGoRoute(
      //       context: context,
      //       state: state,
      //       child: PetInfo(
      //         petModel: pet,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: Routes.kPetRecap,
      //   path: Routes.kPetRecap,
      //   pageBuilder: (context, state) {
      //     final PetModel pet = state.extra as PetModel;
      //     return transitionGoRoute(
      //       context: context,
      //       state: state,
      //       child: Recap(petModel: pet),
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: Routes.kReservationSuccess,
      //   path: Routes.kReservationSuccess,
      //   pageBuilder: (context, state) {
      //     final Map<String, dynamic> extras =
      //         state.extra as Map<String, dynamic>;
      //     final List<Service> services = extras['services'] as List<Service>;
      //     final String providerName = extras['providerName'] as String;
      //     return transitionGoRoute(
      //       context: context,
      //       state: state,
      //       child: ReservationSuccess(
      //         providerName: providerName,
      //         services: services,
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: Routes.kReservationFailure,
      //   path: Routes.kReservationFailure,
      //   pageBuilder: (context, state) {
      //     return transitionGoRoute(
      //       context: context,
      //       state: state,
      //       child: const ReservationFailure(),
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: Routes.kChatScreen,
      //   path: Routes.kChatScreen,
      //   pageBuilder: (context, state) {
      //     return transitionGoRoute(
      //       context: context,
      //       state: state,
      //       child: const ChatScreen(),
      //     );
      //   },
      // ),
    ],
  );
}
