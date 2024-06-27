import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/networking/api_service.dart';

class SignInRepo {
  final ApiService api;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SignInRepo({required this.api});

  Future<Either<Failure, String>> login(
      {required String password, required String userName}) async {
    try {
      var response = await api.post(
        endPoints: 'Provider/SignIn',
        data: {"password": password, "UserName": userName},
      );
      // Check if response is successful
      print(response);
      if (response.data['status'] == 'Success') {
        final token = response.data['token'];
        await _storage.write(key: 'token', value: token);
        debugPrint(
            "=============================== ${response.data['status']}");
        return right(response.data['status'].toString());
      } else {
        // Handle error response
        return left(ServerFailure(response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
