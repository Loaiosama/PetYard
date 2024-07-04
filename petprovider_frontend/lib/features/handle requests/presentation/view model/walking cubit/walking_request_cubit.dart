import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/walking_request.dart';

import 'package:petprovider_frontend/features/handle%20requests/data/repo/walking_repo/walking_request_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/walking%20cubit/walking_request_states.dart';

class WalkingRequestCubit extends Cubit<WalkingRequestState> {
  final WalkingRequestRepoImp repository;

  WalkingRequestCubit(this.repository) : super(WalkingRequestInitial());

  Future<void> fetchPendingWalkingRequests() async {
    emit(WalkingRequestLoading());
    Either<Failure, List<PendingWalkingRequest>> result =
        await repository.getPendingWalkingRequests();

    result.fold(
      (failure) => emit(WalkingRequestFailure(failure.errorMessage)),
      (requests) => emit(WalkingRequestSuccess(requests)),
    );
  }
}
