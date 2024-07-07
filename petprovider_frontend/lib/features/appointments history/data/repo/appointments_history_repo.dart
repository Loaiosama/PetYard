import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/completedmodel/completedmodel.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/pendingmodel/pendingmodel.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/rejectedmodel/rejectedmodel.dart';

abstract class AppointmentHistoryRepo {
  Future<Either<Failure, List<Completedmodel>>> fetchCompletedReservations();
  Future<Either<Failure, List<Rejectedmodel>>> fetchRejectedReservations();
  Future<Either<Failure, List<Pendingmodel>>> fetchPendingReservations();
  // Future<Either<Failure, bool>> addRatingAndReview(
  //     {required int providerId, required double rate, required String review});
}
