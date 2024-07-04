import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/Pet.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/SittingRequest.dart';

abstract class HandelReqRepo {
  Future<Either<Failure, List<SittingRequests>>> fetchRequests();
  Future<Either<Failure, Pet>> getPet({required int id});
  Future<Either<Failure, String>> applyRequest({required int reserveId});
}
