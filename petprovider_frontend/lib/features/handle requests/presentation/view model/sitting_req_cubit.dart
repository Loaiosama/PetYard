import 'package:bloc/bloc.dart';

import 'package:petprovider_frontend/features/handle%20requests/data/repo/handel_req_repo.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/sitting_req_states.dart';

class SittingReqCubit extends Cubit<SittingReqState> {
  final HandelReqRepo reqrepo;

  SittingReqCubit(this.reqrepo) : super(SittingReqInitial());

  Future<void> getAllPendingRequests() async {
    emit(SittingReqLoading());
    var response = await reqrepo.fetchRequests();
    response.fold(
      (failure) => emit(SittingReqFailure(failure.errorMessage)),
      (requests) => emit(SittingReqSuccess(requests)),
    );
  }
}
