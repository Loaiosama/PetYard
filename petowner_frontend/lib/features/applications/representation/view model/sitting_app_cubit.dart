import 'package:bloc/bloc.dart';

import 'package:petowner_frontend/features/applications/data/repo/sitting_app_repo.dart';

import 'package:petowner_frontend/features/applications/representation/view%20model/Sitting_app_states.dart';

class SittingApplicationsCubit extends Cubit<SittingAppState> {
  final SittingAppRepo sittingAppRepo;

  SittingApplicationsCubit(this.sittingAppRepo) : super(SittingAppInitial());

  Future<void> fetchSittingApplications(int ownerId) async {
    emit(SittingAppLoading());
    final result = await sittingAppRepo.fetchSittingApplications(ownerId);
    result.fold(
      (failure) => emit(SittingAppFailure(failure.errorMessage)),
      (applications) => emit(SittingAppSuccess(applications)),
    );
  }
}
