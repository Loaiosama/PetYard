import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/pet%20profile/data/repos/pet_info_repo.dart';

class PetInfoRepoImp extends PetInfoRepo {
  final ApiService apiService;

  PetInfoRepoImp({required this.apiService});

  @override
  Future<Either<Failure, String>> addPetInfo(
      {required PetModel petModel}) async {
    try {
      await apiService.setAuthorizationHeader();
      var response = await apiService.post(
        endPoints: 'PetOwner/AddPet',
        data: petModel.toJson(),
      );

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
