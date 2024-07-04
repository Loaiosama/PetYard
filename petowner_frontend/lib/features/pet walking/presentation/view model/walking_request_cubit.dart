import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/pet%20walking/data/model/walking_request.dart';
import 'package:petowner_frontend/features/pet%20walking/data/repo/walking_request_repo_imp.dart';
import 'package:petowner_frontend/features/pet%20walking/presentation/view%20model/walking_request_states.dart';

class WalkingRequestCubit extends Cubit<WalkingRequestState> {
  final WalkingRepoImp walkingRepo;

  WalkingRequestCubit(this.walkingRepo) : super(WalkingRequestInitial());

  Future<void> sendWalkingRequest(WalkingRequest walkingRequest) async {
    emit(WalkingRequestLoading());
    final Either<Failure, String> response =
        await walkingRepo.sendWalkingrequest(walkingRequest);
    response.fold(
      (failure) => emit(WalkingRequestFailure(failure.errorMessage)),
      (message) => emit(WalkingRequestSuccess(message)),
    );
  }
}
