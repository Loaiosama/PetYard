import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/features/home/data/models/profile_info/profile_info.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo.dart';

class HomeRepoImppl extends HomeRepo {
  final ApiService api;

  HomeRepoImppl({required this.api});
  @override
  Future<Either<Failure, ProfileInfo>> fetchProviderInfo() async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.get(endpoint: 'Provider/GetProviderInfo');

      ProfileInfo profileInfo = const ProfileInfo();
      if (response['status'] == 'Done') {
        profileInfo = ProfileInfo.fromJson(response);
        // print(profileInfo);
        return right(profileInfo);
      } else {
        return left(ServerFailure(response['message']));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createSlot({
    required double price,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.post(
        endPoints: 'Provider/CreateSlot/1',
        data: {
          'Price': price,
          'Start_time': startTime.toIso8601String(),
          'End_time': endTime.toIso8601String(),
        },
      );

      if (response.statusCode == 201) {
        return right(true);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
