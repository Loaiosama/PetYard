import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/profile/data/model/all_pets/all_pets.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo.dart';

part 'pet_info_state.dart';

class PetInfoCubit extends Cubit<PetInfoState> {
  PetInfoCubit(this.profileRepo) : super(PetInfoInitial());

  final ProfileRepo profileRepo;
  AllPetsModel allPetsModel = const AllPetsModel();

  Future<void> getPetInfo({required int id}) async {
    emit(PetInfoLoading());
    var result = await profileRepo.getPetInfo(id: id);

    result.fold((failure) => emit(PetInfoFailure(failure.errorMessage)), (pet) {
      emit(PetInfoSuccess(pet, calculateAge(pet)));
      allPetsModel = pet;
    });
  }

  Future<void> deletePet({required int id}) async {
    try {
      // print('Function Called');
      emit(PetDeleteLoading());
      // print('Function loading');

      await profileRepo.deletePet(id: id);
      emit(const PetDeleteSuccess('Pet Deleted Successfully'));
      // result.fold((failure) {
      //   print('Function failure: ${failure.errorMessage}');
      //   emit(PetDeleteFailure(failure.errorMessage));
      // }, (message) {
      //   print('Function success: $message');
      //   emit(PetDeleteSuccess(message));
      // });
    } catch (e) {
      emit(PetDeleteFailure(e.toString()));
    }
  }

  int calculateAge(AllPetsModel pet) {
    if (pet.data!.isNotEmpty) {
      DateTime now = DateTime.now();
      int age = now.year - (pet.data![0].dateOfBirth!.year);

      // Check if the birthday has already occurred this year
      if (now.month < pet.data![0].dateOfBirth!.month ||
          (now.month == pet.data![0].dateOfBirth!.month &&
              now.day < pet.data![0].dateOfBirth!.day)) {
        age--;
      }
      return age;
    } else {
      // Handle the case where data is empty
      return 0;
    }
  }
}
