import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/model/pet_walking_request.dart';

abstract class UpcomingWalkingRepo {
  Future<Either<Failure, List<WalkingRequest>>> fetchUpcomingWalkingRequests();
  Future<Either<Failure, String>> startWalkingRequest(int reserveId);
}
