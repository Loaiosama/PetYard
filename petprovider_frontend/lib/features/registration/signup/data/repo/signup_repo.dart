import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/networking/api_service.dart';

class SignUpRepo {
  final ApiService api;

  SignUpRepo({required this.api});

  Future<Either<Failure, String>> signUp({
    required String userName,
    required String pass,
    required String email,
    required String phoneNumber,
    required String dateOfBirth,
    required String bio,
    File? image,
  }) async {
    try {
      var response = await api.signup(
        endPoints: 'Provider/SignUp',
        data: {
          "UserName": userName,
          "pass": pass,
          "email": email,
          "phoneNumber": phoneNumber,
          "dateOfBirth": dateOfBirth,
          "Bio": bio,
          "Image": await MultipartFile.fromFile(image!.path),
        },
      );

      if (response.statusCode == 201) {
        return right('Sign up successful');
      } else {
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
