part of 'sign_in_cubit.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInSuccess extends SignInState {
  final String status;

  const SignInSuccess({required this.status});
}

final class SignInFailure extends SignInState {
  final String errorMessage;

  const SignInFailure({required this.errorMessage});
}

final class SelectServiceLoading extends SignInState {}

// final class SelectServiceSuccess extends SignInState {
//   final String successMessage;

//   const SelectServiceSuccess({required this.successMessage});
// }
final class SelectServiceSuccess extends SignInState {
  final String successMessage;
  final List<String> selectedServices;

  const SelectServiceSuccess({
    required this.successMessage,
    required this.selectedServices,
  });

  @override
  List<Object> get props => [successMessage, selectedServices];
}

final class SelectServiceFailure extends SignInState {
  final String errorMessage;

  const SelectServiceFailure({required this.errorMessage});
}

class ServicesUpdated extends SignInState {
  final List<bool> updatedSelectedServices;

  const ServicesUpdated(this.updatedSelectedServices);

  @override
  List<Object> get props => [updatedSelectedServices];
}
