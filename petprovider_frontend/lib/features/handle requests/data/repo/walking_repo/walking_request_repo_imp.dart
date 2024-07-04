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
      await api.setAuthorizationHeader();
      var response = await api.get(endpoint: "Provider/getAllPendingRequests");
      for (var item in response['data']) {
        var req = PendingWalkingRequest.fromJson(item);
        requests.add(req);
      }
      return Right(requests);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
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
