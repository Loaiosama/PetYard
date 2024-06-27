import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';

import 'package:petowner_frontend/features/sitting/data/model/sitting_request%20.dart';

abstract class SittingRepo {
  Future<Either<Failure, String>> sendRequest(SittingRequest req);
}
