import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/profile/data/model/all_pets/all_pets.dart';

abstract class ProfileRepo {
  Future<Either<Failure, List<AllPetsModel>>> getAllPets();
  Future<Either<Failure, AllPetsModel>> getPetInfo({required int id});
  Future<String> deletePet({required int id});
}
