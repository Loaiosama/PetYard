import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/Pet.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/SittingRequest.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/handel_req_repo.dart';

class HandelReqRepoImp extends HandelReqRepo {
  final ApiService api;
  List<SittingRequests> requests = [];

  HandelReqRepoImp({required this.api});
  @override
  Future<Either<Failure, List<SittingRequests>>> fetchRequests() async {
    try {
      print("ana abl el token sitting req");
      await api.setAuthorizationHeader();
      print("ana b3d el token sitting req");
      var response =
          await api.get(endpoint: "Provider/getAllSittingPendingRequests");
      print("ana b3d el repsonse sitting req");

      for (var item in response['data']) {
        var req = SittingRequests.fromJson(item);
        print("ana b3d el req sitting req");
        requests.add(req);
      }
      print("ana able el right  sitting req");
      return Right(requests);
    } catch (e) {
      if (e is DioException) {
        print("ana gwa el e");

        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pet>> getPet({required int id}) async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      print(id);
      var response = await api.get(endpoint: "Provider/GetPetForProvider/$id");
      print(response['data']);

      if (response['data'] != null && response['data'] is List) {
        for (var item in response['data']) {
          var pet = Pet.fromJson(item);
          return Right(pet);
        }
      } else {
        print("Response data is null or not a List");
        return left(ServerFailure("No pet data found"));
      }
    } catch (e) {
      print("ana gwa el e ");
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }

    return left(ServerFailure("Unexpected error occurred"));
  }

  @override
  Future<Either<Failure, String>> applyRequest({required int reserveId}) async {
    try {
      print("Setting authorization header");
      await api.setAuthorizationHeader();
      print("Authorization header set");

      Map<String, dynamic> requestBody = {"Reserve_ID": reserveId};
      print("Request body: $requestBody");

      Response response = await api.post(
        endPoints: "Provider/applySittingRequest",
        data: requestBody,
      );

      print("Response received: ${response.data}");

      if (response.statusCode == 200) {
        return Right(response.data['message']);
      } else {
        return Left(
            ServerFailure("Unexpected status code: ${response.statusCode}"));
      }
    } catch (e) {
      print("Error: $e");
      if (e is DioError) {
        print("DioError: ${e.response?.data}");
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
