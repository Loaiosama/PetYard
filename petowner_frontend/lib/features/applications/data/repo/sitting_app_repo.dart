import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/applications/data/model/pedning_walking_req.dart';
import 'package:petowner_frontend/features/applications/data/model/pending_sitting_req.dart';
import 'package:petowner_frontend/features/applications/data/model/sitting_application.dart';
import 'package:petowner_frontend/features/applications/data/model/update_application.dart';
import 'package:petowner_frontend/features/applications/data/model/walking_application.dart';

abstract class SittingAppRepo {
  Future<Either<Failure, List<SittingApplication>>> fetchSittingApplications(
      int ownerId);
  Future<Either<Failure, List<PendingSittingReq>>>
      fetchPendingSittingRequests();
  Future<Either<Failure, String>> acceptApplication(
      UpdateApplication updateApp);

  Future<Either<Failure, String>> rejectApplication(
      UpdateApplication updateApp);

  Future<Either<Failure, List<PendingWalkingRequest>>> fetchWalkingRequests();
  Future<Either<Failure, String>> acceptWalkingApplication(
      UpdateApplication updateApp);
  Future<Either<Failure, String>> rejectWalkingApplication(
      UpdateApplication updateApp);
  Future<Either<Failure, List<WalkingApplication>>> fetchWalkingApplications(
      int id);
}
