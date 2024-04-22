import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/profile/data/model/all_pets/all_pets.dart';
import 'package:petowner_frontend/features/profile/data/model/all_pets/datum.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImpl extends ProfileRepo {
  ApiService apiService;

  List<AllPetsModel> allPets = [];

  ProfileRepoImpl({
    required this.apiService,
  });

  @override
  Future<Either<Failure, List<AllPetsModel>>> getAllPets() async {
    // print('Ana fe function');
    try {
      // Set authorization header
      // print('Ana abl token');
      await apiService.setAuthorizationHeader();
      // print('Ana b3d token');
      // Make the request
      var response = await apiService.get(endpoint: 'PetOwner/getAllPet');

      // print("actual response hereeeeee $response");
      // if (response['status'] == 'Done') {
      //   print("el resala" + response['message']);
      // }
      // print("Response data: ${response['data']}");

      for (var item in response['data']) {
        // print('item $item');
        var datum = Datum.fromJson(item);
        var allPetsModel = AllPetsModel(
          status: response['status'],
          message: response['message'],
          data: [datum],
        );
        allPets.add(allPetsModel);
      }

      // print(allPets);
      // print('List of pets: ${allPets.length}');
      // for (var allPetsModel in allPets) {
      //   // Iterate over each AllPetsModel object
      //   if (allPetsModel.data == null) {
      //     print('ana null yasta');
      //   }
      //   if (allPetsModel.data != null) {
      //     // Check if the data list is not null
      //     for (var pet in allPetsModel.data!) {
      //       // Iterate over each pet in the data list
      //       print('Pet ID: ${pet.petId}');
      //       print('Type: ${pet.type}');
      //       print('Name: ${pet.name}');
      //       // Add more fields here as needed
      //     }
      //   }
      // }
      // print('Ana b3d token');
      // print(allPets.length);
      // print('fnsakdlfkladshfl ${allPets[0].data![0].name}');
      // return response['data'];

      return right(allPets);
    } catch (e) {
      if (e is DioException) {
        // print('tagroba${ServerFailure.fromDioError(e)}');
        return left(ServerFailure.fromDioError(e));
      }
      // print('fail 2');
      return left(ServerFailure(e.toString()));
    }
  }
}
