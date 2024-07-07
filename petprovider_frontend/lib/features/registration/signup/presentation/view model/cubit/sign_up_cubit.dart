import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repo/signup_repo.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this.signUpRepo) : super(SignUpInitial());
  final SignUpRepo signUpRepo;

  Future<void> signUp({
    required String userName,
    required String pass,
    required String email,
    required String phoneNumber,
    required String dateOfBirth,
    required String bio,
    File? image,
  }) async {
    emit(SignUpLoading());
    await Future.delayed(const Duration(seconds: 1));
    var result = await signUpRepo.signUp(
        userName: userName,
        pass: pass,
        email: email,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        bio: bio,
        image: image);
    result.fold(
        (failure) => emit(SignUpFailure(errorMessage: failure.errorMessage)),
        (success) => emit(SignUpSuccess(status: success)));
  }

  Future<void> validateCode({
    required String email,
    required String validationCode,
  }) async {
    emit(ValidationLoading());
    var result = await signUpRepo.validationCode(
      email: email,
      validationCode: validationCode,
    );
    result.fold(
      (failure) => emit(ValidationFailure(errorMessage: failure.errorMessage)),
      (success) => emit(ValidationSuccess(isValid: success)),
    );
  }
}
