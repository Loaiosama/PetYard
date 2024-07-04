import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/Pet.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/handel_req_repo.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/pet%20cubit/pet_info_state.dart';

class PetInfoCubit extends Cubit<PetInfoState> {
  PetInfoCubit(super.initialState, this.reqRepo);
  final HandelReqRepo reqRepo;

  Future<void> fetchPetInfo({required int id}) async {
    emit(PetInfoLoading());
    var response = await reqRepo.getPet(id: id);

    response.fold(
      (failure) => emit(PetInfofaliure(failure.errorMessage)),
      (pet) {
        int age = calculateAge(pet);
        emit(PetInfoSuccess(pet, age));
      },
    );
  }

  int calculateAge(Pet pet) {
    if (pet.dateOfBirth == null) return 0;
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(pet.dateOfBirth!);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
