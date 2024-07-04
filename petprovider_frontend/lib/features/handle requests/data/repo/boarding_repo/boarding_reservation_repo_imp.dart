import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/boarding_reservation.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/reservation_update.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/boarding_repo/boarding_reservation_repo.dart';

class BoardingReservationRepoImp extends BoardingReservationRepo {
  final ApiService api;
  List<BoardingReservation> reservations = [];

  BoardingReservationRepoImp({required this.api});

  @override
  Future<Either<Failure, List<BoardingReservation>>> fetchReservations() async {
    try {
      await api.setAuthorizationHeader();

      var response =
          await api.get(endpoint: "Provider/GetProviderReservations");

      for (var item in response['data']) {
        var reservation = BoardingReservation.fromJson(item);

        reservations.add(reservation);
      }

      return Right(reservations);
    } catch (e) {
      if (e is DioError) {
        print("e");
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateRservation(
      int reservId, ReservationUpdate reservationUpdate) async {
    try {
      print("before token");
      await api.setAuthorizationHeader();
      print("after token");
      print(reservId);

      var response = await api.put(
        endPoints: "Provider/UpdateReservation/$reservId",
        data: reservationUpdate.toJson(),
      );
      print("after response");

      if (response.statusCode == 200) {
        print("gwa el if");
        String message = response.data['message'];
        print("abl el right");
        return Right(message);
      } else {
        print("abl el left");
        return Left(ServerFailure('Failed to update reservation'));
      }
    } catch (e) {
      if (e is DioError) {
        print("gwa el e ");
        return Left(ServerFailure.fromDioError(e));
      }
      print("bra el e");
      return Left(ServerFailure(e.toString()));
    }
  }
}
