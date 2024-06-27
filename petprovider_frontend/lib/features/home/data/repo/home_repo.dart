import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/home/data/models/profile_info/profile_info.dart';

abstract class HomeRepo {
  Future<Either<Failure, ProfileInfo>> fetchProviderInfo();
  Future<Either<Failure, bool>> createSlot({
    required double price,
    required DateTime startTime,
    required DateTime endTime,
  });
}
