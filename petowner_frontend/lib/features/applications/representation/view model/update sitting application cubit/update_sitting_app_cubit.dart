import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/applications/data/model/update_application.dart';

import 'package:petowner_frontend/features/applications/data/repo/sitting_app_repo_imp.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/update%20sitting%20application%20cubit/update_sitting_app_states.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  final SittingAppRepoImp sittingAppRepo;

  ApplicationCubit({required this.sittingAppRepo})
      : super(ApplicationInitial());

  Future<void> acceptApplication(UpdateApplication updateApp) async {
    emit(ApplicationLoading());
    Either<Failure, String> result =
        await sittingAppRepo.acceptApplication(updateApp);
    result.fold(
      (failure) => emit(ApplicationFailure(failure.toString())),
      (message) => emit(ApplicationSuccess(message)),
    );
  }

  Future<void> rejectApplication(UpdateApplication updateApp) async {
    emit(ApplicationLoading());
    Either<Failure, String> result =
        await sittingAppRepo.rejectApplication(updateApp);
    result.fold(
      (failure) => emit(ApplicationFailure(failure.toString())),
      (message) => emit(ApplicationSuccess(message)),
    );
  }
}
