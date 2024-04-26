import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/home/data/model/provider/provider.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<Provider>>> fetchAllProvidersOfService();
}
