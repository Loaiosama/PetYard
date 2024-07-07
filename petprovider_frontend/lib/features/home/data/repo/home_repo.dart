import 'package:dartz/dartz.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/home/data/models/profile_info/profile_info.dart';
import 'package:petprovider_frontend/features/home/data/models/provider_slots/provider_datum.dart';
import 'package:petprovider_frontend/features/home/data/models/upcoming_events/upcoming_datum.dart';

abstract class HomeRepo {
  Future<Either<Failure, ProfileInfo>> fetchProviderInfo();
  Future<Either<Failure, List<ProviderSlotData>>> getProviderSlots();
  Future<Either<Failure, bool>> deleteSlotById({required int id});
  Future<Either<Failure, bool>> createSlot({
    required double price,
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<Either<Failure, List<UpcomingDatum>>> fetchUpcomingEvents();
}
