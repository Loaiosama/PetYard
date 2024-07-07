import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/model/pet_walking_request.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/repo/upcoming_walking_repo.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';

class UpcomingWalkingRepoImp extends UpcomingWalkingRepo {
  ApiService apiService;
  UpcomingWalkingRepoImp({required this.apiService});
  List<WalkingRequest> requests = [];

  @override
  Future<Either<Failure, List<WalkingRequest>>>
      fetchUpcomingWalkingRequests() async {
    try {
      print("ana abl token upcomig");
      await apiService.setAuthorizationHeader();
      print("ana b3d token ");
      var response =
          await apiService.get(endpoint: "Provider/UpcomingRequestsForWalking");
      print("ana b3d response up coming");
      for (var item in response['data']) {
        print("ana gwa el for");
        var req = WalkingRequest.fromJson(item);
        print("ana b3d el req");
        requests.add(req);
      }
      print("ana abl el right");
      return Right(requests);
    } catch (e) {
      print("ana gwa el e");
      if (e is DioException) {
        print("ana gwa e 2");
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> startWalkingRequest(int reserveId) async {
    try {
      print("abl token");
      await apiService.setAuthorizationHeader();
      print("b3d el token");
      print(reserveId);
      var data = {
        'Reserve_ID': reserveId,
      };
      print("b3d el map");
      var response =
          await apiService.put(endPoints: "Provider/startWalk", data: data);
      print(response);
      print("b3d el response ");
      if (response.statusCode == 200) {
        print("gwa el if");

        String message = response.data['message'];
        print("abl el right");
        return Right(message);
      } else {
        print("ana abl left");
        return Left(ServerFailure('Failed to update reservation'));
      }
    } catch (e) {
      if (e is DioException) {
        print("ana gwa el e");
        return Left(ServerFailure.fromDioError(e));
      }
      print("bra el e");
      return Left(ServerFailure(e.toString()));
    }
  }
}
