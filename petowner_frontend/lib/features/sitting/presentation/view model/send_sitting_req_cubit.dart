import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/sitting/data/model/sitting_request%20.dart';

import 'package:petowner_frontend/features/sitting/data/repo/sitting_repo.dart';
import 'package:petowner_frontend/features/sitting/presentation/view%20model/send_sitting_req_states.dart';

class SittingReqCubit extends Cubit<SittingReqState> {
  final SittingRepo sittingRepo;

  SittingReqCubit({required this.sittingRepo}) : super(SittingReqInitial());

  Future<void> sendReq(SittingRequest req) async {
    emit(SittingReqLoading());

    final Either<Failure, String> result = await sittingRepo.sendRequest(req);

    result.fold(
      (failure) => emit(SittingReqFailure(_mapFailureToMessage(failure))),
      (message) => emit(SittingReqSuccess(message)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // You can customize error messages here
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      default:
        return 'Unexpected error';
    }
  }
}
