import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/reserve%20service/data/models/reserve_service_model/reserve_service_model.dart';
import 'package:petowner_frontend/features/reserve%20service/data/models/reserve_service_model/reserved_slots.dart';
import 'package:petowner_frontend/features/reserve%20service/data/models/reserve_service_model/slots.dart';
import 'package:petowner_frontend/features/reserve%20service/data/repo/reserve_service_repo.dart';

class ReserveServiceRepoImpl extends ReserveServiceRepo {
  ApiService apiService;
  ReserveServiceRepoImpl({
    required this.apiService,
  });

  @override
  Future<Either<Failure, ReserveServiceModel>> fetchBoardingSlots(
      {required int providerId}) async {
    try {
      await apiService.setAuthorizationHeader();

      var response = await apiService.get(
          endpoint: 'Petowner/GetSlotProvider/$providerId/1');

      List<Slots> slots = [];
      List<ReservedSlots> reservedSlots = [];

      for (var item in response['data']) {
        var slot = Slots.fromJson(item);
        slots.add(slot);
      }

      for (var item in response['data1']) {
        var reservedSlot = ReservedSlots.fromJson(item);
        reservedSlots.add(reservedSlot);
      }

      var reserveServiceModel = ReserveServiceModel(
        status: response['status'],
        message: response['message'],
        data: slots,
        data1: reservedSlots,
      );

      return right(reserveServiceModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> feesDisplay(
      {required DateTime startDate,
      required DateTime endDate,
      required int slotID}) async {
    try {
      await apiService.setAuthorizationHeader();
      // print('hellooo');
      var response = await apiService.post(data: {
        "Slot_ID": slotID,
        "Start_time": startDate.toIso8601String(),
        "End_time": endDate.toIso8601String(),
      }, endPoints: 'Petowner/FeesDisplay');

      // print(response.statusCode);
      // print(response.data['Finalcost']);
      int finalCost = 0;
      if (response.statusCode == 201) {
        // print('hena');
        finalCost = response.data['Finalcost'];
        // print('hena');
      }
      return right(finalCost);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> reserveSlot(
      {required DateTime startDate,
      required DateTime endDate,
      required int slotID,
      required int petID}) async {
    try {
      await apiService.setAuthorizationHeader();
      final adjustedStartTime = startDate.add(const Duration(days: 1)).toUtc();
      final adjustedEndTime = endDate.add(const Duration(days: 1)).toUtc();
      // print('hellooo');
      var response = await apiService.post(data: {
        "Slot_ID": slotID,
        "Pet_ID": petID,
        "Start_time": adjustedStartTime.toIso8601String(),
        "End_time": adjustedEndTime.toIso8601String(),
      }, endPoints: 'Petowner/ReserveSlot');

      // print(response.statusCode);
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
