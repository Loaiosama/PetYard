import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';

import 'package:petprovider_frontend/features/handle%20requests/data/model/grooming%20reservation.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/grooming%20repo/grooming_repo.dart';

class GroomingRepoImp extends GroomingRepo {
  final ApiService api;
  GroomingRepoImp({required this.api});
  List<GroomingReservation> reservations = [];
  @override
  Future<Either<Failure, List<GroomingReservation>>>
      getGroomingReservations() async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.get(endpoint: "Provider/upcomingReqGrooming");

      for (var item in response['data']) {
        var reservation = GroomingReservation.fromJson(item);

        reservations.add(reservation);
      }

      return Right(reservations);
    } catch (e) {
      if (e is DioException) {
        print("e");
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
