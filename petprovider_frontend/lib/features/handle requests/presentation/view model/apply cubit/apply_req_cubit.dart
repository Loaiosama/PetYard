import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/handel_req_repo.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20cubit/apply_req_states.dart';

class ApplyReqCubit extends Cubit<ApplyRequestState> {
  final HandelReqRepo reqRepo;
  ApplyReqCubit(super.initialState, this.reqRepo);

  Future<void> applyReq({required int reserveId}) async {
    emit(ApplyRequestLoading());

    var response = await reqRepo.applyRequest(reserveId: reserveId);

    response.fold((faliure) => emit(ApplyRequestFailure(faliure.errorMessage)),
        (message) => emit(ApplyRequestSuccess(message)));
  }
}
