import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/features/grooming/data/models/grooming_slots/grooming_datum.dart';
import 'package:petprovider_frontend/features/grooming/data/repo/grooming_repo.dart';

class GroomingRepoImpl extends GroomingRepo {
  final ApiService api;

  GroomingRepoImpl({required this.api});
  @override
  Future<Either<Failure, bool>> setGroomingType(
      {required String groomingType, required double price}) async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.post(
        endPoints: 'Provider/setGroomingTypes',
        data: {
          "groomingType": groomingType,
          "price": price,
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
  Future<Either<Failure, List<dynamic>>> getGroomingTypeForHome() async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.get(
        endpoint: 'Provider/getGroomingTypes',
      );
      List<dynamic> groomingTypes = response['groomingTypes'];
      // print(groomingTypes);
      if (response['status'] == 'Success') {
        // if (groomingTypes.isEmpty) {
        //   return right('Choose Type');
        // } else {
        //   return right('Set Slot');
        // }
        return right(groomingTypes);
      } else {
        return left(ServerFailure(response['status']));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createGroomingSlot(
      {required DateTime startdate,
      required DateTime enddate,
      required int length}) async {
    try {
      // print(startdate);
      // print(enddate);
      // print(length);
      await api.setAuthorizationHeader();
      var response = await api.post(
        endPoints: 'Provider/createGroomingSlots',
        data: {
          "Start_time": startdate.toIso8601String(),
          "End_time": enddate.toIso8601String(),
          "Slot_length": length,
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
  Future<Either<Failure, List<GroomingDatum>>> getGroomingSlots() async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.get(endpoint: 'Provider/getGroomingSlots');
      if (response['status'] == 'Success') {
        List<GroomingDatum> slotsList = [];
        for (var item in response['data']) {
          slotsList.add(GroomingDatum.fromJson(item));
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
  Future<Either<Failure, bool>> updatePriceForService(
      {required double price, required String type}) async {
    try {
      // print(startdate);
      // print(enddate);
      // print(length);
      await api.setAuthorizationHeader();
      var response = await api.put(
        endPoints: 'Provider/updatePriceForService',
        data: {"Price": price, "Grooming_Type": type},
      );

      if (response.statusCode == 200) {
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
