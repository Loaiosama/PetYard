import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/applications/data/model/pedning_walking_req.dart';

import 'package:petowner_frontend/features/applications/representation/view%20model/walking%20request%20cubit/pending_walking_request_states.dart';

import '../../../data/repo/sitting_app_repo_imp.dart';

class WalkingRequestsCubit extends Cubit<WalkingRequestsState> {
  final SittingAppRepoImp repo;

  WalkingRequestsCubit(this.repo) : super(WalkingRequestsInitial());

  Future<void> fetchWalkingRequests() async {
    emit(WalkingRequestsLoading());
    Either<Failure, List<PendingWalkingRequest>> result =
        await repo.fetchWalkingRequests();
    result.fold(
      (failure) => emit(WalkingRequestsFailure(failure.errorMessage)),
      (requests) => emit(WalkingRequestsSuccess(requests)),
    );
  }
}
