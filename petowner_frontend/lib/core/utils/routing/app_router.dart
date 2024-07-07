import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/routing/routing_animation.dart';
import 'package:petowner_frontend/core/widgets/reservation_failure.dart';
import 'package:petowner_frontend/core/widgets/reservation_success.dart';
import 'package:petowner_frontend/features/Requests/representation/view/choose_request.dart';
import 'package:petowner_frontend/features/chat%20old/presentation/view/chat_screen.dart';
import 'package:petowner_frontend/features/chat/data/repo/chat_service.dart';
import 'package:petowner_frontend/features/chat/presentation/view/chat.dart';
import 'package:petowner_frontend/features/chat/presentation/view_model/test/cubit/chathistory_cubit.dart';
import 'package:petowner_frontend/features/grooming/presentation/view/grooming_home.dart';
import 'package:petowner_frontend/features/home/presentation/view/home.dart';
import 'package:petowner_frontend/features/home/presentation/view/service_providers_screen.dart';
import 'package:petowner_frontend/features/onboarding/onboarding_screen2.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
// import 'package:petowner_frontend/features/onboarding/presentation/onboarding_screen.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/pet_breed.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/pet_info.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/pet_type.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/recap.dart';
import 'package:petowner_frontend/features/profile/presentation/view/location_screen.dart';
import 'package:petowner_frontend/features/profile/presentation/view/personal_information.dart';
import 'package:petowner_frontend/features/profile/presentation/view/pet_information.dart';
import 'package:petowner_frontend/features/profile/presentation/view/profile_screen.dart';
import 'package:petowner_frontend/features/profile/presentation/view/widgets/settings_screen.dart';
import 'package:petowner_frontend/features/provider%20profile/data/models/provider_info_model/data.dart';
import 'package:petowner_frontend/features/provider%20profile/presentation/view/provider_profile_screen.dart';
import 'package:petowner_frontend/features/registration/signin/presentation/view/forgot_password.dart';
import 'package:petowner_frontend/features/registration/signin/presentation/view/signin.dart';
import 'package:petowner_frontend/features/registration/signup/presentation/view/signup.dart';
import 'package:petowner_frontend/features/reserve%20service/presentation/view/reserve_appointment_screen.dart';
import 'package:petowner_frontend/features/sitting/data/model/sitting_request%20.dart';
import 'package:petowner_frontend/features/sitting/presentation/view/pet_sitting.dart';
import 'package:petowner_frontend/features/sitting/presentation/view/request_success.dart';
import 'package:petowner_frontend/features/splash/splash_view.dart';
import 'package:petowner_frontend/features/tracking/presentation/view/walking_traking.dart';

import '../../../features/applications/data/model/pedning_walking_req.dart';
import '../../../features/applications/data/model/pending_sitting_req.dart';
import '../../../features/applications/representation/view/applications.dart';
import '../../../features/applications/representation/view/widgets/sitting_applications.dart';
import '../../../features/applications/representation/view/widgets/walking_applications.dart';
import '../../../features/pet walking/data/model/walking_request.dart';
import '../../../features/pet walking/presentation/view/pet_walking.dart';
import '../../../features/pet walking/presentation/view/widget/walking_success.dart';

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
      // Navigate to forget password screen
      GoRoute(
        path: Routes.kForgotPasswordScreen,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: Routes.kProfileScreen,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: const ProfileScreen(),
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
          name: Routes.kProviderProfile,
          path: Routes.kProviderProfile,
          pageBuilder: (context, state) {
            final Map<String, dynamic> extras =
                state.extra as Map<String, dynamic>;
            final int id = extras['id'] as int;
            final String serviceName = extras['serviceName'] as String;
            return transitionGoRoute(
              context: context,
              state: state,
              child: ProviderProfileScreen(
                id: id,
                serviceName: serviceName,
              ),
            );
          }),
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
        name: Routes.kbookAppointment,
        path: Routes.kbookAppointment,
        pageBuilder: (context, state) {
          final Map<String, dynamic> extras =
              state.extra as Map<String, dynamic>;
          final int providerId = extras['providerId'] as int;
          final String serviceName = extras['serviceName'] as String;
          final String providerName = extras['providerName'] as String;
          final List<Service> services = extras['services'] as List<Service>;
          return transitionGoRoute(
            context: context,
            state: state,
            child: BookAppointment(
              services: services,
              serviceName: serviceName,
              providerId: providerId,
              providerName: providerName,
            ),
          );
        },
      ),
      GoRoute(
        name: Routes.kgroomingHome,
        path: Routes.kgroomingHome,
        pageBuilder: (context, state) {
          final Map<String, dynamic> extras =
              state.extra as Map<String, dynamic>;
          final int providerId = extras['providerId'] as int;
          final String serviceName = extras['serviceName'] as String;
          final String providerName = extras['providerName'] as String;
          final List<Service> services = extras['services'] as List<Service>;
          return transitionGoRoute(
            context: context,
            state: state,
            child: GroomingHomeScreen(
              services: services,
              serviceName: serviceName,
              providerId: providerId,
              providerName: providerName,
            ),
          );
        },
      ),
      GoRoute(
        name: Routes.kServiceProviders,
        path: Routes.kServiceProviders,
        pageBuilder: (context, state) {
          final String service = state.extra as String;
          return transitionGoRoute(
            context: context,
            state: state,
            child: ServiceProvidersScreen(
              serviceName: service,
            ),
          );
        },
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
      GoRoute(
        name: Routes.kReservationSuccess,
        path: Routes.kReservationSuccess,
        pageBuilder: (context, state) {
          final Map<String, dynamic> extras =
              state.extra as Map<String, dynamic>;
          final List<Service> services = extras['services'] as List<Service>;
          final String providerName = extras['providerName'] as String;
          final String serviceName = extras['serviceName'] as String;
          final DateTime startTime = extras['startTime'] as DateTime;
          final DateTime endTime = extras['endTime'] as DateTime;
          final DateTime date = extras['date'] as DateTime;
          return transitionGoRoute(
            context: context,
            state: state,
            child: ReservationSuccess(
              providerName: providerName,
              services: services,
              serviceName: serviceName,
              date: date,
              endTime: endTime,
              startTime: startTime,
            ),
          );
        },
      ),
      GoRoute(
        name: Routes.kReservationFailure,
        path: Routes.kReservationFailure,
        pageBuilder: (context, state) {
          return transitionGoRoute(
            context: context,
            state: state,
            child: const ReservationFailure(),
          );
        },
      ),
      GoRoute(
        name: Routes.KChooseReq,
        path: Routes.KChooseReq,
        pageBuilder: (context, state) {
          return transitionGoRoute(
            context: context,
            state: state,
            child: const ChooseRequest(),
          );
        },
      ),
      GoRoute(
        name: Routes.KPetSitting,
        path: Routes.KPetSitting,
        pageBuilder: (context, state) {
          return transitionGoRoute(
            context: context,
            state: state,
            child: const PetSitting(),
          );
        },
      ),

      GoRoute(
        name: Routes.KSuccessReq,
        path: Routes.KSuccessReq,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final SittingRequest req = args['request'] as SittingRequest;
          final String petName = args['selectedName'] as String;

          return transitionGoRoute(
            context: context,
            state: state,
            child: Requestscuccess(req: req, PetName: petName),
          );
        },
      ),
      // GoRoute(
      //   name: Routes.kChatScreen,
      //   path: Routes.kChatScreen,
      //   pageBuilder: (context, state) {
      //     return transitionGoRoute(
      //       context: context,
      //       state: state,
      //       child: ChatScreen(),
      //     );
      //   },
      // ),
      GoRoute(
          name: Routes.kChatScreen,
          path: Routes.kChatScreen,
          pageBuilder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final int senderId = extras['senderId'] as int;
            final int receiverId = extras['receiverId'] as int;
            final String role = extras['role'] as String;
            return transitionGoRoute(
                context: context,
                state: state,
                child: BlocProvider(
                  create: (context) => ChathistoryCubit(
                      ChatService(apiService: ApiService(dio: Dio()))),
                  child: OwnerChatScreen(
                    receiverId: receiverId,
                    role: role,
                    senderId: senderId,
                  ),
                ));
          }),
      GoRoute(
        name: Routes.kSettings,
        path: Routes.kSettings,
        pageBuilder: (context, state) {
          return transitionGoRoute(
            context: context,
            state: state,
            child: const SettingsScreen(),
          );
        },
      ),

      GoRoute(
        name: Routes.KApplications,
        path: Routes.KApplications,
        pageBuilder: (context, state) {
          return transitionGoRoute(
            context: context,
            state: state,
            child: const Applications(),
          );
        },
      ),
      GoRoute(
          name: Routes.KSittingApplications,
          path: Routes.KSittingApplications,
          pageBuilder: (context, state) {
            final PendingSittingReq req = state.extra as PendingSittingReq;
            return transitionGoRoute(
              context: context,
              state: state,
              child: SittingApplications(req: req),
            );
          }),
      GoRoute(
          name: Routes.KWalkingApplications,
          path: Routes.KWalkingApplications,
          pageBuilder: (context, state) {
            final PendingWalkingRequest req =
                state.extra as PendingWalkingRequest;
            return transitionGoRoute(
              context: context,
              state: state,
              child: WalkingApplications(req: req),
            );
          }),
      GoRoute(
        name: Routes.KWalkingSuccess,
        path: Routes.KWalkingSuccess,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final WalkingRequest req = args['request'] as WalkingRequest;
          final String petName = args['selectedName'] as String;

          return transitionGoRoute(
            context: context,
            state: state,
            child: WalkingSuccess(req: req, PetName: petName),
          );
        },
      ),
      GoRoute(
        name: Routes.KPetWalking,
        path: Routes.KPetWalking,
        pageBuilder: (context, state) {
          return transitionGoRoute(
            context: context,
            state: state,
            child: const PetWalking(),
          );
        },
      ),
      GoRoute(
          name: Routes.KTrackWalk,
          path: Routes.KTrackWalk,
          pageBuilder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            final double lat = args['lat'] as double;
            final double long = args['long'] as double;
            final int radius = args['radius'] as int;
            return transitionGoRoute(
                context: context,
                state: state,
                child: TrackingWalking(
                  lat: lat,
                  long: long,
                  radius: radius,
                ));
          }),
    ],
  );
}
