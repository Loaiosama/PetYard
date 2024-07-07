import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/features/chat/presentation/view/chat.dart';
import 'package:petprovider_frontend/features/chat/data/repo/chat_service.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/routing/routing_animation.dart';
import 'package:petprovider_frontend/features/grooming/data/repo/grooming_repo_impl.dart';
import 'package:petprovider_frontend/features/grooming/presentation/view/choose_grooming_types.dart';
import 'package:petprovider_frontend/features/grooming/presentation/view_model/choose_types_cubit/grooming_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/Pet.dart';
import 'package:petprovider_frontend/features/home/data/models/upcoming_events/upcoming_datum.dart';
import 'package:petprovider_frontend/features/home/presentation/view/home.dart';
import 'package:petprovider_frontend/features/home/presentation/view/widgets/available_slots_screen.dart';
import 'package:petprovider_frontend/features/home/presentation/view/widgets/see_all_upcoming_events.dart';
import 'package:petprovider_frontend/features/pet%20profile/data/model/owner.dart';
import 'package:petprovider_frontend/features/pet%20profile/presentation/view/pet_owner_profile.dart';
import 'package:petprovider_frontend/features/pet%20profile/presentation/view/pet_profile.dart';
import 'package:petprovider_frontend/features/registration/signin/data/repo/sign_in_repo.dart';
import 'package:petprovider_frontend/features/registration/signin/presentation/view/widgets/choose_service.dart';
import 'package:petprovider_frontend/features/registration/signin/presentation/view_model/signin_cubit/sign_in_cubit.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/fill_information.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/validation_code.dart';
import 'package:petprovider_frontend/features/chat/presentation/view_model/test/cubit/chathistory_cubit.dart';
import 'package:petprovider_frontend/features/tracking/peresentation/view/tracking.dart';

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
          name: Routes.kValidationCode,
          path: Routes.kValidationCode,
          pageBuilder: (context, state) {
            final String email = state.extra as String;
            return transitionGoRoute(
              context: context,
              state: state,
              child: ValidationCodeScreen(
                email: email,
              ),
            );
          }),
      GoRoute(
        path: Routes.kChooseService,
        pageBuilder: (context, state) => transitionGoRoute(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) =>
                SignInCubit(SignInRepo(api: ApiService(dio: Dio()))),
            child: const ChooseService(),
          ),
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
            final Map<String, dynamic> extras =
                state.extra as Map<String, dynamic>;
            final String serviceName = extras['serviceName'] as String;
            final List<dynamic> groomingTypes = extras['groomingTypes'] as List;
            return transitionGoRoute(
              context: context,
              state: state,
              child: AvaialableSlotsScreen(
                serviceName: serviceName,
                groomingTypes: groomingTypes,
              ),
            );
          }),
      GoRoute(
          name: Routes.kChooseGroomingTypes,
          path: Routes.kChooseGroomingTypes,
          pageBuilder: (context, state) {
            // final String serviceName = state.extra as String;
            final Map<String, dynamic> extras =
                state.extra as Map<String, dynamic>;
            final String serviceName = extras['serviceName'] as String;
            final List<dynamic> groomingTypes =
                extras['groomingTypes'] as List<dynamic>;
            return transitionGoRoute(
              context: context,
              state: state,
              child: BlocProvider(
                create: (context) => GroomingCubit(
                    GroomingRepoImpl(api: ApiService(dio: Dio()))),
                child: ChooseGroomingTypeScreen(
                  serviceName: serviceName,
                  groomingTypes: groomingTypes,
                ),
              ),
            );
          }),
      GoRoute(
        name: Routes.KPetProfile,
        path: Routes.KPetProfile,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final Pet pet = args['pet'] as Pet;
          final int age = args['age'] as int;
          final int ownerId = args['ownerId'] as int; // Extract ownerId

          return transitionGoRoute(
            context: context,
            state: state,
            child: PetProfile(
              pet: pet,
              age: age,
              ownerId: ownerId, // Pass ownerId to PetProfile
            ),
          );
        },
      ),
      GoRoute(
          name: Routes.KPetOwnerProfile,
          path: Routes.KPetOwnerProfile,
          pageBuilder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            final Owner owner = args['onwer'] as Owner;
            final Pet pet = args['pet'] as Pet;

            return transitionGoRoute(
                context: context,
                state: state,
                child: PetOwnerProfile(
                  owner: owner,
                  pet: pet,
                ));
          }),
      GoRoute(
          name: Routes.kSeeAllUpcomingEvents,
          path: Routes.kSeeAllUpcomingEvents,
          pageBuilder: (context, state) {
            final List<UpcomingDatum> data = state.extra as List<UpcomingDatum>;
            return transitionGoRoute(
                context: context,
                state: state,
                child: SeeAllUpcomingEvents(
                  data: data,
                ));
          }),
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
                  child: ProviderChatScreen(
                    receiverId: receiverId,
                    role: role,
                    senderId: senderId,
                  ),
                ));
          }),
      GoRoute(
          name: Routes.KTrackWalk,
          path: Routes.KTrackWalk,
          pageBuilder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            final double lat = args['lat'] as double;
            final double long = args['long'] as double;
            final double radius = args['radius'] as double;
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
