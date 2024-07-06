import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/applications/data/model/Pet.dart';
import 'package:petowner_frontend/features/applications/data/model/pedning_walking_req.dart';
import 'package:petowner_frontend/features/applications/data/model/pending_sitting_req.dart';
import 'package:petowner_frontend/features/applications/data/model/sitting_application.dart';
import 'package:petowner_frontend/features/applications/data/model/update_application.dart';
import 'package:petowner_frontend/features/applications/data/model/walking_application.dart';
import 'package:petowner_frontend/features/applications/data/repo/sitting_app_repo.dart';

class SittingAppRepoImp extends SittingAppRepo {
  ApiService api;
  List<SittingApplication> applications = [];
  List<WalkingApplication> walkingApplications = [];
  List<PendingSittingReq> requests = [];
  List<PendingWalkingRequest> walkingRequests = [];
  SittingAppRepoImp({
    required this.api,
  });
  @override
  Future<Either<Failure, List<SittingApplication>>> fetchSittingApplications(
      int ownerId) async {
    try {
      print("abl token sitting app");
      await api.setAuthorizationHeader();
      print("b3d token sitting app");
      var response =
          await api.get(endpoint: "PetOwner/getSittingApplications/$ownerId");
      print("b3d response sitting app");
      for (var item in response['data']) {
        print("in for sitting app");
        var app = SittingApplication.fromJson(item);
        print("b3d app sitting app");
        applications.add(app);
      }
      print("abl right sitting app");
      return right(applications);
    } catch (e) {
      print("gwa el e");
      if (e is DioException) {
        print("able left");
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PendingSittingReq>>>
      fetchPendingSittingRequests() async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      var response = await api.get(endpoint: "PetOwner/getSittingRequests");
      print("ana b3d el response");
      print(response['reservations']);
      for (var item in response['reservations']) {
        print("ana gwa el if ");
        var req = PendingSittingReq.fromJson(item);
        print("ana b3d el var");
        requests.add(req);
        print("ana b3d el add");
      }
      print("ana abl el right");
      return right(requests);
    } catch (e) {
      if (e is DioException) {
        print("ana gwa el e");
        return left(ServerFailure.fromDioError(e));
      }
      print("ana bara el e");
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Pet>> getPet({required int id}) async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      print(id);
      var response = await api.get(endpoint: 'PetOwner/getPet/$id');
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
  Future<Either<Failure, String>> acceptApplication(
      UpdateApplication updateApp) async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      var response = await api.put(
          endPoints: "PetOwner/acceptSittingApplication",
          data: updateApp.toJson());
      print("ana b3d el el rsponse");
      if (response.statusCode == 200) {
        print("ana gwa myten om el if");
        String message = response.data['message'];
        print("ana abl myten om el right");
        return Right(message);
      } else {
        print("ana abl el left ya rb ma 22ablo");
        return Left(ServerFailure('Failed to update reservation'));
      }
    } catch (e) {
      if (e is DioException) {
        print("a7a ana gwa el e");

        return Left(ServerFailure.fromDioError(e));
      }
      print("bra el e");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> rejectApplication(
      UpdateApplication updateApp) async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      var response = await api.put(
          endPoints: "PetOwner/rejectApplication", data: updateApp.toJson());
      print("ana b3d el el rsponse");
      if (response.statusCode == 200) {
        print("ana gwa myten om el if");
        String message = response.data['message'];
        print("ana abl myten om el right");
        return Right(message);
      } else {
        print("ana abl el left ya rb ma 22ablo");
        return Left(ServerFailure('Failed to update reservation'));
      }
    } catch (e) {
      if (e is DioException) {
        print("gwa el e ");
        return Left(ServerFailure.fromDioError(e));
      }
      print("bra el e");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PendingWalkingRequest>>>
      fetchWalkingRequests() async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      var response =
          await api.get(endpoint: "PetOwner/GetPendingWalkingRequests");
      print("ana b3d el response");
      print(response['reservations']);
      for (var item in response['reservations']) {
        print("ana gwa el if ");
        var req = PendingWalkingRequest.fromJson(item);
        print("ana b3d el var");
        walkingRequests.add(req);
        print("ana b3d el add");
      }
      print("ana abl el right");
      return right(walkingRequests);
    } catch (e) {
      if (e is DioException) {
        print("ana gwa el e");
        return left(ServerFailure.fromDioError(e));
      }
      print("ana bara el e");
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> acceptWalkingApplication(
      UpdateApplication updateApp) async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      var response = await api.put(
          endPoints: "PetOwner/acceptWalkingApplication",
          data: updateApp.toJson());
      print("ana b3d el el rsponse");
      if (response.statusCode == 200) {
        print("ana gwa myten om el if");
        String message = response.data['message'];
        print("ana abl myten om el right");
        return Right(message);
      } else {
        print("ana abl el left ya rb ma 22ablo");
        return Left(ServerFailure('Failed to update reservation'));
      }
    } catch (e) {
      if (e is DioException) {
        print("a7a ana gwa el e");

        return Left(ServerFailure.fromDioError(e));
      }
      print("bra el e");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> rejectWalkingApplication(
      UpdateApplication updateApp) async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      var response = await api.put(
          endPoints: "PetOwner/rejectWalkingApplication",
          data: updateApp.toJson());
      print("ana b3d el el rsponse");
      if (response.statusCode == 200) {
        print("ana gwa myten om el if");
        String message = response.data['message'];
        print("ana abl myten om el right");
        return Right(message);
      } else {
        print("ana abl el left ya rb ma 22ablo");
        return Left(ServerFailure('Failed to update reservation'));
      }
    } catch (e) {
      if (e is DioException) {
        print("gwa el e ");
        return Left(ServerFailure.fromDioError(e));
      }
      print("bra el e");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalkingApplication>>> fetchWalkingApplications(
      int id) async {
    try {
      await api.setAuthorizationHeader();
      var response =
          await api.get(endpoint: "PetOwner/GetWalkingApplications/$id");
      for (var item in response['data']) {
        var app = WalkingApplication.fromJson(item);
        walkingApplications.add(app);
      }
      return right(walkingApplications);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
