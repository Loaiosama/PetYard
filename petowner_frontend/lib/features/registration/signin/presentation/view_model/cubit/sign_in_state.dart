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
