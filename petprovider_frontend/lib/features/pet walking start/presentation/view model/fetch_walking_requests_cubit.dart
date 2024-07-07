import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/model/pet_walking_request.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/repo/upcoming_walking_repo.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/presentation/view%20model/fetch_walking_requests_states.dart';

class UpcomingWalkingCubit extends Cubit<UpcomingWalkingState> {
  final UpcomingWalkingRepo repo;

  UpcomingWalkingCubit(this.repo) : super(UpcomingWalkingInitial());

  Future<void> fetchUpcomingWalkingRequests() async {
    emit(UpcomingWalkingLoading());
    Either<Failure, List<WalkingRequest>> result =
        await repo.fetchUpcomingWalkingRequests();
    result.fold(
      (failure) => emit(UpcomingWalkingFailure(failure.errorMessage)),
      (requests) => emit(UpcomingWalkingSuccess(requests)),
    );
  }
}
