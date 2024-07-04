import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';

class SignUpRepo {
  final ApiService api;

  SignUpRepo({required this.api});

  Future<Either<Failure, String>> signUp({
    required String firstName,
    required String lastName,
    required String pass,
    required String email,
    required String phoneNumber,
    required String dateOfBirth,
  }) async {
    try {
      var response = await api.post(
        endPoints: 'PetOwner/SignUp',
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "pass": pass,
          "email": email,
          "phoneNumber": phoneNumber,
          "dateOfBirth": dateOfBirth,
        },
      );
      // print('RESPONSE CODE ==== ${response.statusCode}');
      // Check if response is successful
      if (response.statusCode == 201) {
        debugPrint(
            "=============================== ${response.data['message']}");
        return right('Sign up successful');
      } else {
        // If there's an error, return a failure wrapped in ServerFailure
        return left(ServerFailure('Failed to sign up'));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
