import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/model/data/walking_track_request.dart';

abstract class WalkingTrackRepo {
  Future<Either<Failure, List<WalkingTrackRequest>>>
      fetchUpcomingWalkingRequests();
  Future<Either<Failure, String>> trackWalkingRequest(int reserveId);
}
