
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/pet%20profile/data/pet_model.dart';
import 'package:petowner_frontend/features/pet%20profile/data/repos/pet_info_repo.dart';


class PetInfoRepoImp extends PetInfoRepo {
  final ApiService apiService;
 

  PetInfoRepoImp({required this.apiService});
  @override
  Future<Either<Failure ,void >> addPetInfo({required PetModel petModel}) async {
    try {
      await apiService.setAuthorizationHeader();
      var response = await apiService.post(
        endPoints: 'PetOwner/AddPet',
        data: petModel.toJson(),
      );
      // Check if response is successful
      return response.data ;
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
