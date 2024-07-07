import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/pet%20walking/data/model/walking_request.dart';
import 'package:petowner_frontend/features/pet%20walking/data/repo/walking_request_repo.dart';

class WalkingRepoImp extends WalkingRepo {
  WalkingRepoImp({required this.apiService});
  ApiService apiService;

  @override
  Future<Either<Failure, String>> sendWalkingrequest(
      WalkingRequest walkingRequest) async {
    try {
      print("ana abl el token");
      await apiService.setAuthorizationHeader();
      print("ana b3d el token");
      final startAdjusted =
          walkingRequest.startTime!.add(const Duration(hours: 0)).toUtc();
      final endAdjusted =
          walkingRequest.endTime!.add(const Duration(hours: 0)).toUtc();
      walkingRequest.startTime = startAdjusted;
      walkingRequest.endTime = endAdjusted;
      var response = await apiService.post(
          endPoints: "PetOwner/makeWalkingRequest",
          data: walkingRequest.toJson());
      print("ana b3d el response");
      if (response.statusCode == 201) {
        print("ana abl el right");
        return right(response.data['message']);
      } else {
        return left(
            ServerFailure('Failed to send the request. Please try again.'));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
