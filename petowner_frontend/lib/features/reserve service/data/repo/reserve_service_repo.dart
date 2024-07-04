import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/reserve%20service/data/models/reserve_service_model/reserve_service_model.dart';

abstract class ReserveServiceRepo {
  Future<Either<Failure, ReserveServiceModel>> fetchBoardingSlots(
      {required int providerId});
  Future<Either<Failure, int>> feesDisplay(
      {required DateTime startDate,
      required DateTime endDate,
      required int slotID});
  Future<bool> reserveSlot({
    required DateTime startDate,
    required DateTime endDate,
    required int slotID,
    required int petID,
  });
}
