import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/features/pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/core/errors/failure.dart';

abstract class PetInfoRepo {
  Future<Either<Failure, String>> addPetInfo({required PetModel petModel});
}
