import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/grooming/data/models/grooming_slots/grooming_datum.dart';

abstract class GroomingRepo {
  Future<Either<Failure, bool>> setGroomingType(
      {required String groomingType, required double price});
  Future<Either<Failure, List<dynamic>>> getGroomingTypeForHome();
  Future<Either<Failure, bool>> createGroomingSlot(
      {required DateTime startdate,
      required DateTime enddate,
      required int length});

  Future<Either<Failure, List<GroomingDatum>>> getGroomingSlots();
  Future<Either<Failure, bool>> updatePriceForService(
      {required double price, required String type});
  Future<Either<Failure, bool>> deleteType({required int id});
}
