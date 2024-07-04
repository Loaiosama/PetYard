import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/core/errors/failure.dart';

abstract class PetInfoRepo {
  Future<Either<Failure, String>> addPetInfo({
    required PetModel petModel,
    File? image,
    required String type,
    required String name,
    required String gender,
    required String breed,
    required DateTime dateOfBirth,
    required DateTime adoptionDate,
    required String weight,
    required String bio,
  });
}
