import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:petowner_frontend/features/applications/data/repo/sitting_app_repo_imp.dart';
import 'package:petowner_frontend/features/applications/representation/view%20model/pet%20cubit/fetch_pet_states.dart';

class FetchPetCubit extends Cubit<FetchPetState> {
  FetchPetCubit(super.initialState, this.reqAppRepo);
  final SittingAppRepoImp reqAppRepo;

  Future<void> fetchPetInfo({required int id}) async {
    emit(FetchPetLoading());
    var response = await reqAppRepo.getPet(id: id);

    response.fold(
      (failure) => emit(FetchPetFailure(failure.errorMessage)),
      (pet) {
        emit(FetchPetSuccess(pet));
      },
    );
  }
}
