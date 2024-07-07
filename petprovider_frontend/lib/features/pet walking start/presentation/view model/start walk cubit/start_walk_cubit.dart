import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/repo/upcoming_walking_repo.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/presentation/view%20model/start%20walk%20cubit/start_walk_states.dart';

class StartWalkingRequestCubit extends Cubit<StartWalkingRequestState> {
  final UpcomingWalkingRepo repo;

  StartWalkingRequestCubit(this.repo) : super(StartWalkingRequestInitial());

  Future<void> startWalkingRequest(int reserveId) async {
    emit(StartWalkingRequestLoading());
    Either<Failure, String> result = await repo.startWalkingRequest(reserveId);
    result.fold(
      (failure) => emit(StartWalkingRequestFailure(failure.errorMessage)),
      (message) => emit(StartWalkingRequestSuccess(message)),
    );
  }
}
