import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/applications/data/model/update_application.dart';

import 'package:petowner_frontend/features/applications/data/repo/sitting_app_repo_imp.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/update%20walking%20application%20cubit/update_walking_app_states.dart';

class WalkingUpdaetCubit extends Cubit<WalkingState> {
  final SittingAppRepoImp repo;

  WalkingUpdaetCubit(this.repo) : super(WalkingInitial());

  Future<void> acceptWalkingRequest(UpdateApplication updateApp) async {
    emit(WalkingLoading());
    Either<Failure, String> result =
        await repo.acceptWalkingApplication(updateApp);
    result.fold(
      (failure) => emit(WalkingFailure(failure.toString())),
      (message) => emit(WalkingSuccess(message)),
    );
  }

  Future<void> rejectWalkingRequest(UpdateApplication updateApp) async {
    emit(WalkingLoading());
    Either<Failure, String> result =
        await repo.rejectWalkingApplication(updateApp);
    result.fold(
      (failure) => emit(WalkingFailure(failure.toString())),
      (message) => emit(WalkingSuccess(message)),
    );
  }
}
