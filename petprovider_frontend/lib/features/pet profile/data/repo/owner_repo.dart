import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/pet%20profile/data/model/owner.dart';

abstract class OwnerRepo {
  Future<Either<Failure, Owner>> fetchOwnerInfo(int Owner_ID);
}
