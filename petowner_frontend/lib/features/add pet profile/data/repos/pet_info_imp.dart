import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/repos/pet_info_repo.dart';

class PetInfoRepoImp extends PetInfoRepo {
  final ApiService apiService;

  PetInfoRepoImp({required this.apiService});

  @override
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
  }) async {
    try {
      await apiService.setAuthorizationHeader();
      print('object');
      print(petModel.adoptionDate);
      print(
        petModel.name,
      );
      print(File(image!.path));
      print(adoptionDate);
      var response = await apiService.addPet(
        endPoints: 'PetOwner/AddPet',
        data: {
          'Name': name,
          'Type': type,
          'Breed': breed,
          'Gender': gender,
          'Date_of_birth': dateOfBirth.toIso8601String(),
          'Adoption_Date': adoptionDate.toIso8601String(),
          'Weight': weight,
          'Bio': bio,
          'Image': await MultipartFile.fromFile(image.path),
        },
      );
      print('fasdf');
      print(response);
      if (response.statusCode == 200) {
        // Return a Right with the success message
        return right(response.data['message']);
      } else {
        // Return a Left with a failure message
        return left(ServerFailure('Failed to add pet. Please try again.'));
      }
    } catch (e) {
      // Return a Left with a failure message if an exception occurs
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
