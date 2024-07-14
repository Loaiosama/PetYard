import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/appointments%20history/data/models/acceptedmodel/acceptedmodel.dart';
import 'package:petowner_frontend/features/appointments%20history/data/models/completedmodel/completedmodel.dart';
import 'package:petowner_frontend/features/appointments%20history/data/models/pendingmodel/pendingmodel.dart';
import 'package:petowner_frontend/features/appointments%20history/data/models/rejectedmodel/rejectedmodel.dart';

abstract class AppointmentHistoryRepo {
  Future<Either<Failure, List<Completedmodel>>> fetchCompletedReservations();
  Future<Either<Failure, List<Acceptedmodel>>> fetchAcceptedReservations();
  Future<Either<Failure, List<Rejectedmodel>>> fetchRejectedReservations();
  Future<Either<Failure, List<Pendingmodel>>> fetchPendingReservations();
  Future<Either<Failure, bool>> addRatingAndReview(
      {required int providerId, required double rate, required String review});
  Future<Either<Failure, bool>> markAsDoneBoarding(
      {required int reserveId, required String type});
  Future<Either<Failure, bool>> markAsDoneWalking({
    required int reserveId,
    required int providerId,
  });
  Future<Either<Failure, bool>> markAsDoneSitting({
    required int reserveId,
    required int providerId,
  });
  Future<Either<Failure, bool>> markAsDoneGrooming({
    required int reserveId,
  });
}
