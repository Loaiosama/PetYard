// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/acceptedmodel/acceptedmodel.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/completedmodel/completedmodel.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/completedmodel/datum.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/pendingmodel/pended_datum.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/pendingmodel/pendingmodel.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/repo/appointments_history_repo.dart';

import '../models/rejectedmodel/rejected_datum.dart';
import '../models/rejectedmodel/rejectedmodel.dart';

class AppointmentHistoryImpl extends AppointmentHistoryRepo {
  ApiService apiService;

  List<Completedmodel> completedReservations = [];
  List<Pendingmodel> pendingReservations = [];
  List<Rejectedmodel> rejectedReservations = [];
  List<Acceptedmodel> acceptedReservations = [];

  AppointmentHistoryImpl({
    required this.apiService,
  });

  @override
  Future<Either<Failure, List<Completedmodel>>>
      fetchCompletedReservations() async {
    try {
      await apiService.setAuthorizationHeader();

      var response = await apiService.get(endpoint: 'Provider/GetALLCompleted');

      for (var item in response['data']) {
        // print(item);

        var datum = Datum.fromJson(item);
        var completedModel = Completedmodel(
          status: response['status'],
          message: response['message'],
          data: [datum],
        );
        completedReservations.add(completedModel);
      }
      return right(completedReservations);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Pendingmodel>>> fetchPendingReservations() async {
    try {
      await apiService.setAuthorizationHeader();

      var response = await apiService.get(endpoint: 'Provider/GetAllPending');

      for (var item in response['data']) {
        var datum = PendedDatum.fromJson(item);
        var pendedModel = Pendingmodel(
          status: response['status'],
          message: response['message'],
          data: [datum],
        );
        pendingReservations.add(pendedModel);
      }
      return right(pendingReservations);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Rejectedmodel>>>
      fetchRejectedReservations() async {
    try {
      await apiService.setAuthorizationHeader();

      var response = await apiService.get(endpoint: 'Provider/GetAllRejected');

      for (var item in response['data']) {
        var datum = RejectedDatum.fromJson(item);
        var rejectedModel = Rejectedmodel(
          status: response['status'],
          message: response['message'],
          data: [datum],
        );
        rejectedReservations.add(rejectedModel);
      }
      return right(rejectedReservations);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, bool>> addRatingAndReview(
  //     {required int providerId,
  //     required double rate,
  //     required String review}) async {
  //   try {
  //     await apiService.setAuthorizationHeader();

  //     var response = await apiService.post(
  //       endPoints: 'Petowner/AddRating?providerid=$providerId',
  //       data: {
  //         "rate": rate,
  //         "comment": review,
  //       },
  //     );

  //     bool result = false;
  //     if (response.statusCode == 201) {
  //       result = true;
  //     }
  //     return right(result);
  //   } catch (e) {
  //     if (e is DioException) {
  //       return left(ServerFailure.fromDioError(e));
  //     }
  //     return left(ServerFailure(e.toString()));
  //   }
  // }
}
