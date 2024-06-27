import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
// import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/registration/signin/data/repo/sign_in_repo.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.signInRepo) : super(SignInInitial());

  final SignInRepo signInRepo;

  Future<void> signIn({required String password, required String email}) async {
    emit(SignInLoading());
    await Future.delayed(const Duration(seconds: 1));
    var result = await signInRepo.login(password: password, email: email);
    result.fold(
        (failure) => emit(SignInFailure(errorMessage: failure.errorMessage)),
        (status) => emit(SignInSuccess(status: status)));
  }
}
