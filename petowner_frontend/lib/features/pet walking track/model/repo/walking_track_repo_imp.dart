import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/model/data/walking_track_request.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/model/repo/walking_track_repo.dart';

class WalkingTrackRepoImp extends WalkingTrackRepo {
  ApiService apiService;
  WalkingTrackRepoImp({required this.apiService});
  List<WalkingTrackRequest> requests = [];
  @override
  Future<Either<Failure, List<WalkingTrackRequest>>>
      fetchUpcomingWalkingRequests() async {
    try {
      print("ana abl el token");
      await apiService.setAuthorizationHeader();
      print("ana b3d el token");
      var response =
          await apiService.get(endpoint: "PetOwner/UpcomingOwnerRequests");
      print("ana b3d el response");
      for (var item in response['data']) {
        print("ana gwa el for");
        var req = WalkingTrackRequest.fromJson(item);
        print("ana b3d el request");
        requests.add(req);
      }
      print("ana abl el right");
      return Right(requests);
    } catch (e) {
      print("ana gwa el e ");
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      print("ana bara el e");
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> trackWalkingRequest(int reserveId) async {
    try {
      print("abl token track");
      await apiService.setAuthorizationHeader();
      print("b3d el token track");
      print(reserveId);

      print("b3d el map track");
      var response = await apiService.get(
          endpoint: "PetOwner/trackWalkingRequest/$reserveId");
      print(response);
      print("b3d el response track ");

      return Right(response['message']);
    } catch (e) {
      if (e is DioException) {
        print("ana gwa el e track");
        return Left(ServerFailure.fromDioError(e));
      }
      print("bra el e track");
      return Left(ServerFailure(e.toString()));
    }
  }
}
