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
    try {
      await apiService.setAuthorizationHeader();

      var response = await apiService.get(endpoint: 'PetOwner/getAllPet');

      for (var item in response['data']) {
        var datum = Datum.fromJson(item);
        var allPetsModel = AllPetsModel(
          status: response['status'],
          message: response['message'],
          data: [datum],
        );
        allPets.add(allPetsModel);
      }
      return right(allPets);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AllPetsModel>> getPetInfo({required int id}) async {
    try {
      await apiService.setAuthorizationHeader();

      var response = await apiService.get(endpoint: 'PetOwner/getPet/$id');
      AllPetsModel allPetsModel = const AllPetsModel();
      for (var item in response['data']) {
        // print('item $item');
        var datum = Datum.fromJson(item);
        allPetsModel = AllPetsModel(
          status: response['status'],
          message: response['message'],
          data: [datum],
        );
        // allPets.add(allPetsModel);
      }
      // print(allPetsModel.data![0].name);
      return right(allPetsModel);
    } catch (e) {
      if (e is DioException) {
        // print('tagroba${ServerFailure.fromDioError(e)}');
        return left(ServerFailure.fromDioError(e));
      }
      // print('fail 2');
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<String> deletePet({required int id}) async {
    try {
      await apiService.setAuthorizationHeader();

      var response =
          await apiService.delete(endPoints: 'PetOwner/RemovePet/$id');
      return response.data['message'];
    } catch (e) {
      return e.toString();
      // if (e is DioException) {
      //   // print('tagroba${ServerFailure.fromDioError(e)}');
      //   return left(ServerFailure.fromDioError(e));
      // }
      // // print('fail 2');
      // return left(ServerFailure(e.toString()));
    }
  }
}
