import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/grooming/data/models/grooming_pending_slots/grooming_pending_slots.dart';

abstract class GroomingRepo {
  Future<Either<Failure, List<GroomingPendingSlots>>> groomingPendingSlots(
      {required int providerId});
  Future<Either<Failure, double>> feesDisplay(
      {required List<String> groomingTypes, required int providerId});
  Future<bool> reserveGroomingSlot(
      {required int slotID, required int petID, required List groomingTypes});
  Future<Either<Failure, List<String>>> getGroomingTypes({required providerId});
}
