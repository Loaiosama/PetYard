import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/features/home/data/models/profile_info/profile_info.dart';
import 'package:petprovider_frontend/features/home/data/models/provider_slots/provider_datum.dart';
import 'package:petprovider_frontend/features/home/data/models/upcoming_events/upcoming_datum.dart';
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

  @override
  Future<Either<Failure, List<ProviderSlotData>>> getProviderSlots() async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.get(endpoint: 'Provider/GetAllSlots');
      if (response['status'] == 'Done') {
        List<ProviderSlotData> slotsList = [];
        for (var item in response['data']) {
          slotsList.add(ProviderSlotData.fromJson(item));
        }
        return right(slotsList);
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
  Future<Either<Failure, bool>> deleteSlotById({required int id}) async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.delete(endPoints: 'Provider/DeleteSlot/$id');
      if (response.data['status'] == "Success") {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UpcomingDatum>>> fetchUpcomingEvents() async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.get(endpoint: 'Provider/UpcomingRequests');
      // print(response);
      if (response['status'] == 'Success') {
        // print('fas');
        List<UpcomingDatum> eventsList = [];
        for (var item in response['data']) {
          // print(item);
          eventsList.add(UpcomingDatum.fromJson(item));
        }
        // print(eventsList);
        return right(eventsList);
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
}
