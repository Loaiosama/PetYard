import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/features/pet%20profile/data/pet_model.dart';
import 'package:petowner_frontend/core/errors/failure.dart';

abstract class PetInfoRepo {
  Future<Either<Failure , void>> addPetInfo({required PetModel petModel});

}
