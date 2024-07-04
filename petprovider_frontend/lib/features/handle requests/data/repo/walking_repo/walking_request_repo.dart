import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/walking_request.dart';

abstract class WalkingRequestRepo {
  Future<Either<Failure, List<PendingWalkingRequest>>>
      getPendingWalkingRequests();
  Future<Either<Failure, String>> applyWalkingRequest(int reservationId);
}
