import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/repos/pet_info_imp.dart';

part 'add_pet_info_state.dart';

class AddPetInfoCubit extends Cubit<AddPetInfoState> {
  final PetInfoRepoImp petInfoRepoImp;
  AddPetInfoCubit(this.petInfoRepoImp) : super(AddPetInfoInitial());
  Future<void> addPetInfo({
    required PetModel petModel,
    required File image,
    required String type,
    required String name,
    required String gender,
    required String breed,
    required DateTime dateOfBirth,
    required DateTime adoptionDate,
    required String weight,
    required String bio,
  }) async {
    var result = await petInfoRepoImp.addPetInfo(
        petModel: petModel,
        image: image,
        adoptionDate: adoptionDate,
        bio: bio,
        breed: breed,
        gender: gender,
        name: name,
        type: type,
        dateOfBirth: dateOfBirth,
        weight: weight);
    emit(AddPetInfoloading());
    result.fold(
        (failure) =>
            emit(AddPetInfoFaliure(errorMessage: failure.errorMessage)),
        (success) => emit(AddPetInfoSuccess(successMessage: success)));
  }
}
