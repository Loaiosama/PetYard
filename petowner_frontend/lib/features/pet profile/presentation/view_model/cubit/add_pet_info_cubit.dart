import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:petowner_frontend/features/pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/pet%20profile/data/repos/pet_info_imp.dart';

part 'add_pet_info_state.dart';

class AddPetInfoCubit extends Cubit<AddPetInfoState> {
  final PetInfoRepoImp petInfoRepoImp;
  AddPetInfoCubit(this.petInfoRepoImp) : super(AddPetInfoInitial());
  Future<void> addPetInfo(PetModel petModel) async {
    var result = await petInfoRepoImp.addPetInfo(petModel: petModel);
    emit(AddPetInfoloading());
    result.fold(
        (failure) =>
            emit(AddPetInfoFaliure(errorMessage: failure.errorMessage)),
        (success) => emit(AddPetInfoSuccess(successMessage: success)));
  }
}
