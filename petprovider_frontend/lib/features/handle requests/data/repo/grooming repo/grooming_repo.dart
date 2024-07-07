import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/grooming%20reservation.dart';

abstract class GroomingRepo {
  Future<Either<Failure, List<GroomingReservation>>> getGroomingReservations();
}
