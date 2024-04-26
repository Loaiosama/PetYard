import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/provider%20profile/data/models/provider_info_model/provider_info_model.dart';
import 'package:petowner_frontend/features/provider%20profile/data/repos/provider_info_repo.dart';

part 'provider_info_state.dart';

class ProviderInfoCubit extends Cubit<ProviderInfoState> {
  ProviderInfoCubit(this.providerInfoRepo) : super(ProviderInfoInitial());
  final ProviderInfoRepo providerInfoRepo;

  Future<void> getProviderInfo({required int id}) async {
    emit(ProviderInfoLoading());
    var result = await providerInfoRepo.getProviderInfo(id: id);

    result.fold((failure) => emit(ProviderInfoFailure(failure.errorMessage)),
        (pet) {
      emit(ProviderInfoSuccess(pet));
    });
  }
}
