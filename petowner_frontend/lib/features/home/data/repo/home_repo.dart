import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/home/data/model/provider/provider.dart';
import 'package:petowner_frontend/features/home/data/model/provider_sorted/provider_sorted.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<Provider>>> fetchAllProvidersOfService(
      {required String serviceName});
  Future<Either<Failure, List<ProviderSorted>>> fetchProvidersSortedByRating(
      {required int rating, required String serviceName});
}
