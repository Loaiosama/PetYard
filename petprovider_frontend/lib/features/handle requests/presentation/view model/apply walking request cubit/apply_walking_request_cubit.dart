import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';

import 'package:petprovider_frontend/features/handle%20requests/data/repo/walking_repo/walking_request_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20walking%20request%20cubit/apply_walking_request_states.dart';

class ApplyWalkingRequestCubit extends Cubit<ApplyWalkingRequestState> {
  final WalkingRequestRepoImp walkingRequestRepo;

  ApplyWalkingRequestCubit(this.walkingRequestRepo)
      : super(ApplyWalkingRequestInitial());

  Future<void> applyWalkingRequest(int reservationId) async {
    emit(ApplyWalkingRequestLoading());
    Either<Failure, String> result =
        await walkingRequestRepo.applyWalkingRequest(reservationId);

    result.fold(
      (failure) => emit(ApplyWalkingRequestFailure(failure.errorMessage)),
      (message) => emit(ApplyWalkingRequestSuccess(message)),
    );
  }
}
