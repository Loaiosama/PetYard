import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/profile/data/model/all_pets/all_pets.dart';
import 'package:petowner_frontend/features/profile/data/model/owner_info/owner_info.dart';

abstract class ProfileRepo {
  Future<Either<Failure, OwnerInfo>> getOwnerInfo();
  Future<bool> updateOwnerInfo({
    required String firstName,
    required String lastName,
    required String pass,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
  });
  Future<Either<Failure, List<AllPetsModel>>> getAllPets();
  Future<Either<Failure, AllPetsModel>> getPetInfo({required int id});
  Future<String> deletePet({required int id});
}
