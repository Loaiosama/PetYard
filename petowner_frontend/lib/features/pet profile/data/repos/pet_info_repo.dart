import 'package:petowner_frontend/features/pet%20profile/data/pet_model.dart';

abstract class PetInfoRepo {
  Future<void> addPetInfo({required PetModel petModel});
  Future<List<PetModel>> fetchPetInfo();
}
