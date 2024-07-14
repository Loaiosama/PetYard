import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repo/sign_in_repo.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.signInRepo) : super(SignInInitial());

  final SignInRepo signInRepo;

  // List of services with icon and name
  final List<Map<String, dynamic>> services = [
    {'icon': 'choose_boarding.svg', 'name': 'Pet Boarding'},
    {'icon': 'choose_walking.svg', 'name': 'Pet Walking'},
    {'icon': 'choose_grooming.svg', 'name': 'Pet Grooming'},
    {'icon': 'choose_sitting.svg', 'name': 'Pet Sitting'},
  ];

  List<bool> selectedServices = [false, false, false, false];

  Future<void> signIn(
      {required String password, required String userName}) async {
    emit(SignInLoading());
    await Future.delayed(const Duration(seconds: 1));
    var result = await signInRepo.login(password: password, userName: userName);
    result.fold(
      (failure) => emit(SignInFailure(errorMessage: failure.errorMessage)),
      (status) => emit(SignInSuccess(status: status)),
    );
  }

  // Future<void> selectService(String type) async {
  //   emit(SelectServiceLoading());
  //   await Future.delayed(const Duration(seconds: 1));
  //   final result = await signInRepo.selectService(type: type);

  //   result.fold(
  //     (failure) =>
  //         emit(SelectServiceFailure(errorMessage: failure.errorMessage)),
  //     (message) => emit(SelectServiceSuccess(successMessage: message)),
  //   );
  // }
  Future<void> selectService(List<String> selectedServices) async {
    emit(SelectServiceLoading());
    await Future.delayed(const Duration(seconds: 1));

    for (String service in selectedServices) {
      final result = await signInRepo.selectService(type: service);
      result.fold(
        (failure) =>
            emit(SelectServiceFailure(errorMessage: failure.errorMessage)),
        (message) {
          // Emit success with the selected services
          emit(SelectServiceSuccess(
            successMessage: message,
            selectedServices: selectedServices,
          ));
        },
      );
    }
  }

  void clickService(int index) {
    selectedServices[index] = !selectedServices[index];
    emit(ServicesUpdated(List.from(selectedServices))); // Emit updated state
  }
}
