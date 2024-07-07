import 'package:dartz/dartz.dart';
import 'package:petowner_frontend/core/errors/failure.dart';

import 'package:petowner_frontend/features/sitting/data/model/sitting_request%20.dart';
import 'package:petowner_frontend/features/sitting/data/repo/sitting_repo.dart';

import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

import 'package:petowner_frontend/core/utils/networking/api_service.dart';

class SittingRepoImp extends SittingRepo {
  ApiService apiService;

  SittingRepoImp({
    required this.apiService,
  });

  @override
  Future<Either<Failure, String>> sendRequest(SittingRequest req) async {
    try {
      await apiService.setAuthorizationHeader();
      final startAdjusted =
          req.startTime!.add(const Duration(hours: 0)).toUtc();
      final endAdjusted = req.endTime!.add(const Duration(hours: 0)).toUtc();
      req.endTime = endAdjusted;
      req.startTime = startAdjusted;

      var response = await apiService.post(
          endPoints: 'PetOwner/makeSittingRequest', data: req.toJson());

      if (response.statusCode == 201) {
        return right(response.data['message']);
      } else {
        return left(
            ServerFailure('Failed to send the request. Please try again.'));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
