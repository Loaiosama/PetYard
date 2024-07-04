import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/grooming/data/models/grooming_pending_slots/grooming_pending_datum.dart';
import 'package:petowner_frontend/features/grooming/data/models/grooming_pending_slots/grooming_pending_slots.dart';
import 'package:petowner_frontend/features/grooming/data/repo/grooming_repo.dart';

class GroomingRepoImpl extends GroomingRepo {
  final ApiService apiService;

  GroomingRepoImpl({required this.apiService});

  @override
  Future<Either<Failure, List<GroomingPendingSlots>>> groomingPendingSlots(
      {required int providerId}) async {
    try {
      await apiService.setAuthorizationHeader();

      var response = await apiService.get(
          endpoint: 'PetOwner/getPendingGroomingSlotsForProvider/$providerId');
      GroomingPendingSlots groomingPendingDatum = const GroomingPendingSlots();
      List<GroomingPendingSlots> groomingSlots = [];
      // print(response);
      for (var item in response['data']) {
        // print('item $item');
        var datum = GroomingPendingDatum.fromJson(item);
        groomingPendingDatum = GroomingPendingSlots(
          status: response['status'],
          message: response['message'],
          data: [datum],
        );
        groomingSlots.add(groomingPendingDatum);
        // print(groomingSlots);
      }
      // print('groomingSlots $groomingSlots');
      return right(groomingSlots);
    } catch (e) {
      if (e is DioException) {
        // print('tagroba${ServerFailure.fromDioError(e)}');
        return left(ServerFailure.fromDioError(e));
      }
      // print('fail 2');
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> feesDisplay({
    required List<String> groomingTypes,
    required int providerId,
  }) async {
    try {
      await apiService.setAuthorizationHeader();
      var response = await apiService.post(
        data: {
          "provider_id":
              providerId.toString(), // Ensure the provider_id is a string
          "grooming_types":
              groomingTypes, // Ensure grooming_types is a List<String>
        },
        endPoints: 'Petowner/getFees',
      );
      // print('grromming type $groomingTypes');
      // print('Response status code: ${response.statusCode}');
      // print('Response data: ${response.data}');

      double finalCost = 0;
      if (response.statusCode == 200) {
        if (response.data != null &&
            response.data['data'] != null &&
            response.data['data']['finalPrice'] != null) {
          var finalPrice = response.data['data']['finalPrice'];
          if (finalPrice is int) {
            finalCost = finalPrice.toDouble();
          } else if (finalPrice is String) {
            finalCost = double.tryParse(finalPrice) ?? 0;
          } else {
            // print('Unexpected type for finalPrice');
            return left(ServerFailure('Unexpected type for finalPrice'));
          }
          // print('Parsed finalCost: $finalCost');
        } else {
          // print('Response data is not in expected format');
          return left(ServerFailure('Unexpected response format'));
        }
      } else {
        // print('Response status code is not 200');
        return left(
            ServerFailure('Unexpected status code: ${response.statusCode}'));
      }
      return right(finalCost);
    } catch (e) {
      // print('Exception caught: $e');
      if (e is DioException) {
        // print('DioException details: ${e.response?.data}');
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> reserveGroomingSlot(
      {required int slotID,
      required int petID,
      required List groomingTypes}) async {
    try {
      await apiService.setAuthorizationHeader();
      // print('hellooo');
      var response = await apiService.post(data: {
        "slot_id": slotID,
        "pet_id": petID,
        "grooming_types": groomingTypes,
      }, endPoints: 'Petowner/bookGroomingSlot');

      // print(response.statusCode);
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, List<String>>> getGroomingTypes(
      {required providerId}) async {
    try {
      await apiService.setAuthorizationHeader();
      final response = await apiService.get(
          endpoint: 'Petowner/getGroomingTypes/$providerId');
      // print(response);
      if (response['status'] == 'Success') {
        List<dynamic> data = response['groomingTypes'];
        return right(
            data.map((type) => type['grooming_type'] as String).toList());
      } else {
        return left(ServerFailure('Failed to load grooming types'));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
