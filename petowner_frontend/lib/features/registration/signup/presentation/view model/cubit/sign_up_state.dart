part of 'sign_up_cubit.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  final String status;

  const SignUpSuccess({required this.status});
}

final class SignUpFailure extends SignUpState {
  final String errorMessage;

  const SignUpFailure({required this.errorMessage});
}

final class ValidationLoading extends SignUpState {}

final class ValidationSuccess extends SignUpState {
  final bool isValid;

  const ValidationSuccess({required this.isValid});
}

final class ValidationFailure extends SignUpState {
  final String errorMessage;

  const ValidationFailure({required this.errorMessage});
}
