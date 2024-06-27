import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repo/sign_in_repo.dart';
// import 'package:petowner_frontend/core/errors/failure.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.signInRepo) : super(SignInInitial());

  final SignInRepo signInRepo;

  Future<void> signIn({required String password, required String userName}) async {
    emit(SignInLoading());
    await Future.delayed(const Duration(seconds: 1));
    var result = await signInRepo.login(password: password, userName: userName);
    result.fold(
        (failure) => emit(SignInFailure(errorMessage: failure.errorMessage)),
        (status) => emit(SignInSuccess(status: status)));
  }
}
