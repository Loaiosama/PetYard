import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/applications/data/model/pending_sitting_req.dart';
import 'package:petowner_frontend/features/applications/data/repo/sitting_app_repo.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/pending%20requests%20cubit/pending_sitting_req_states.dart';

class PendingSittingRequestsCubit extends Cubit<PendingSittingRequestsState> {
  final SittingAppRepo sittingAppRepo;

  PendingSittingRequestsCubit(this.sittingAppRepo)
      : super(PendingSittingRequestsInitial());

  Future<void> fetchPendingSittingRequests() async {
    print("abl el loading");
    emit(PendingSittingRequestsLoading());
    print("b3d el loading");
    Either<Failure, List<PendingSittingReq>> response =
        await sittingAppRepo.fetchPendingSittingRequests();
    print("b3del either");
    response.fold(
      (failure) => emit(PendingSittingRequestsFailure(failure.errorMessage)),
      (requests) => emit(PendingSittingRequestsSuccess(requests)),
    );
  }
}
