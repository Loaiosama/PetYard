import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/registration/signup/data/repo/signup_repo.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this.signUpRepo) : super(SignUpInitial());
  final SignUpRepo signUpRepo;
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String pass,
    required String email,
    required String phoneNumber,
    required String dateOfBirth,
  }) async {
    emit(SignUpLoading());
    await Future.delayed(const Duration(seconds: 1));
    var result = await signUpRepo.signUp(
        firstName: firstName,
        lastName: lastName,
        pass: pass,
        email: email,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth);
    result.fold(
        (failure) => emit(SignUpFailure(errorMessage: failure.errorMessage)),
        (success) => emit(SignUpSuccess(status: success)));
  }
}
