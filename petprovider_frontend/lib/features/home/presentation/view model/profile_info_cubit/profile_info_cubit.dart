import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/home/data/models/profile_info/profile_info.dart';
import 'package:petprovider_frontend/features/home/data/models/provider_slots/provider_datum.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo_impl.dart';

part 'profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  ProfileInfoCubit(this.homeRepoImppl) : super(ProfileInfoInitial());
  final HomeRepoImppl homeRepoImppl;

  Future<void> fetchProviderInfo() async {
    emit(ProfileInfoLoading());
    var result = await homeRepoImppl.fetchProviderInfo();
    result.fold(
        (failue) => emit(ProfileInfoFailure(errorMessage: failue.errorMessage)),
        (profileInfo) => emit(ProfileInfoSuccess(profileInfo: profileInfo)));
  }

  Future<void> fetchProviderSlots() async {
    emit(ProviderSlotLoading());
    var result = await homeRepoImppl.getProviderSlots();
    result.fold(
      (failue) => emit(ProviderSlotFailure(errorMessage: failue.errorMessage)),
      (slots) => emit(
        ProviderSlotSuccess(
          slots: slots,
        ),
      ),
    );
  }

  Future<void> deleteProviderSlotById({required int id}) async {
    var result = await homeRepoImppl.deleteSlotById(id: id);
    result.fold(
      (fail) => emit(DeleteSlotFailure(isSuccess: fail.errorMessage)),
      (success) => emit(
        DeleteSlotSuccess(isSuccess: success),
      ),
    );
  }
}
