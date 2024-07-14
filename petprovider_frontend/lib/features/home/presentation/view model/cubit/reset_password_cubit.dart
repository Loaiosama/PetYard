import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo_impl.dart';
import 'package:petprovider_frontend/features/home/presentation/view%20model/cubit/reset_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final HomeRepoImppl signInRepo;

  ChangePasswordCubit(this.signInRepo) : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());
    final result = await signInRepo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => emit(ChangePasswordFailure(_mapFailureToMessage(failure))),
      (message) => emit(ChangePasswordSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.errorMessage;
    }
    return 'Unexpected error';
  }
}
