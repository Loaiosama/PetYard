import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/pet%20walking/data/model/walking_request.dart';

abstract class WalkingRepo {
  Future<Either<Failure, String>> sendWalkingrequest(
      WalkingRequest walkingRequest);
}
