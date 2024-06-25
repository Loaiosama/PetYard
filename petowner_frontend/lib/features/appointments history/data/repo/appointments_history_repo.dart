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
}
