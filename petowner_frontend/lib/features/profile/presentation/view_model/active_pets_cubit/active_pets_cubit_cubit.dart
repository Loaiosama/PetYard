// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:petowner_frontend/features/profile/data/model/all_pets/all_pets.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo.dart';

part 'active_pets_cubit_state.dart';

class ActivePetsCubitCubit extends Cubit<ActivePetsCubitState> {
  ActivePetsCubitCubit(
    this.profileRepo,
  ) : super(ActivePetsCubitInitial());

  final ProfileRepo profileRepo;

  Future<void> getAllPets() async {
    emit(ActivePetsCubitLoading());
    var result = await profileRepo.getAllPets();

    result.fold(
      (failure) => emit(
        ActivePetsCubitFailure(failure.errorMessage),
      ),
      (pets) => emit(
        ActivePetsCubitSuccess(pets),
      ),
    );
  }
}
