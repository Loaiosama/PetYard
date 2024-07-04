import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/features/pet%20profile/data/model/owner.dart';
import 'package:petprovider_frontend/features/pet%20profile/data/repo/owner_repo.dart';

class OwnerRepoImp extends OwnerRepo {
  final ApiService api;

  OwnerRepoImp({required this.api});

  @override
  Future<Either<Failure, Owner>> fetchOwnerInfo(int ownerId) async {
    try {
      print("ana abl el token");
      await api.setAuthorizationHeader();
      print("ana b3d el token");
      var response = await api.get(endpoint: "Provider/GetOwnerInfo/$ownerId");
      print("ana b3d el response");
      print(response['data'].toString());
      print(response['status'].toString());

      if (response['status'] == "Success") {
        print("ana gwa el if");
        var owner = Owner.fromJson(response['data']);
        print("ana abl el right");

        return Right(owner);
      }
    } catch (e) {
      if (e is DioError) {
        print("abl gwa el e");
        return Left(ServerFailure.fromDioError(e));
      }
      print("ana bara el e");
      return Left(ServerFailure(e.toString()));
    }

    // Add a default return statement to satisfy the return type
    return Left(ServerFailure("Unexpected error occurred"));
  }
}
