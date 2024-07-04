import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/boarding_reservation.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/reservation_update.dart';

abstract class BoardingReservationRepo {
  Future<Either<Failure, List<BoardingReservation>>> fetchReservations();
  Future<Either<Failure, String>> updateRservation(
      int reservId, ReservationUpdate reservationUpdate);
}
