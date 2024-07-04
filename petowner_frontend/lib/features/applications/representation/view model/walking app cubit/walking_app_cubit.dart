import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';

import 'package:petowner_frontend/features/applications/data/model/walking_application.dart';
import 'package:petowner_frontend/features/applications/data/repo/sitting_app_repo_imp.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/walking%20app%20cubit/walking_app_states.dart';

class WalkingApplicationsCubit extends Cubit<WalkingApplicationsState> {
  final SittingAppRepoImp repo;

  WalkingApplicationsCubit(this.repo) : super(WalkingApplicationsInitial());

  Future<void> fetchWalkingApplications(int ownerId) async {
    emit(WalkingApplicationsLoading());
    Either<Failure, List<WalkingApplication>> result =
        await repo.fetchWalkingApplications(ownerId);
    result.fold(
      (failure) => emit(WalkingApplicationsFailure(failure.errorMessage)),
      (applications) => emit(WalkingApplicationsSuccess(applications)),
    );
  }
}
