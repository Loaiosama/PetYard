import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/model/repo/walking_track_repo_imp.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/presentation/view%20model/track%20walking%20cubit/track_walking_states.dart';

class TrackWalkingRequestCubit extends Cubit<TrackWalkingState> {
  final WalkingTrackRepoImp repo;

  TrackWalkingRequestCubit(this.repo) : super(TrackWalkingInitial());

  Future<void> startWalkingRequest(int reserveId) async {
    emit(TrackWalkingLoading());
    Either<Failure, String> result = await repo.trackWalkingRequest(reserveId);
    result.fold(
      (failure) => emit(TrackWalkingFailure(failure.errorMessage)),
      (message) => emit(TrackWalkingSuccess(message)),
    );
  }
}
