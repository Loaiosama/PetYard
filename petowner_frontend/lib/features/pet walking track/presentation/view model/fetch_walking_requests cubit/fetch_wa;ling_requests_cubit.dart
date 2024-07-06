import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/model/data/walking_track_request.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/model/repo/walking_track_repo_imp.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/presentation/view%20model/fetch_walking_requests%20cubit/fetch_walking_requests._states.dart';
import 'package:petowner_frontend/features/pet%20walking/data/model/walking_request.dart';

class UpcomingWalkingCubit extends Cubit<UpcomingWalkingState> {
  final WalkingTrackRepoImp repo;

  UpcomingWalkingCubit(this.repo) : super(UpcomingWalkingInitial());

  Future<void> fetchUpcomingWalkingRequests() async {
    emit(UpcomingWalkingLoading());
    Either<Failure, List<WalkingTrackRequest>> result =
        await repo.fetchUpcomingWalkingRequests();
    result.fold(
      (failure) => emit(UpcomingWalkingFailure(failure.errorMessage)),
      (requests) => emit(UpcomingWalkingSuccess(requests)),
    );
  }
}
