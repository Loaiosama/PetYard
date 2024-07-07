import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/walking_request.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/walking_repo/walking_request_repo.dart';

class WalkingRequestRepoImp extends WalkingRequestRepo {
  final ApiService api;
  List<PendingWalkingRequest> requests = [];
  WalkingRequestRepoImp({required this.api});

  @override
  Future<Either<Failure, List<PendingWalkingRequest>>>
      getPendingWalkingRequests() async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      var response = await api.get(endpoint: "Provider/getAllPendingRequests");
      print("ana b3d el response");
      for (var item in response['data']) {
        print("ana gwa el if");
        var req = PendingWalkingRequest.fromJson(item);
        print("ana b3d el req");
        requests.add(req);
      }
      print("ana abl el right");
      return Right(requests);
    } catch (e) {
      if (e is DioException) {
        print("ana gwa el e ");
        return left(ServerFailure.fromDioError(e));
      }
      print("ana bra el e");
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> applyWalkingRequest(int reservationId) async {
    try {
      await api.setAuthorizationHeader();
      Map<String, dynamic> requestBody = {"reservationId": reservationId};
      Response response = await api.post(
        endPoints: "Provider/applyForWalkingRequest",
        data: requestBody,
      );
      if (response.statusCode == 200) {
        return Right(response.data['message']);
      } else {
        return Left(
            ServerFailure("Unexpected status code: ${response.statusCode}"));
      }
    } catch (e) {
      if (e is DioException) {
        print("DioError: ${e.response?.data}");
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
