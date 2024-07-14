// import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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

      if (response.data['status'] == 'Success') {
        final token = response.data['token'];
        await _storage.write(key: 'token', value: token);

        await api.setAuthorizationHeader();

        // Fetch provider info after successful login
        var providerInfoResponse =
            await api.get(endpoint: 'Provider/GetProviderInfo');
        // print(providerInfoResponse['status']);
        // print(providerInfoResponse['data']);
        if (providerInfoResponse['status'] == 'Done') {
          List<dynamic> data = providerInfoResponse['data'];
          // print(data);
          bool hasSelectedServices =
              data.isNotEmpty; // Check if services are already selected
          // print(!hasSelectedServices);
          if (hasSelectedServices) {
            return right('Login Successful');
          } else {
            return right('Choose Services');
          }
        } else {
          return left(ServerFailure(providerInfoResponse['message']));
        }
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  // login function to cache grooming types so we wont have to call it in the home screen
  // ##################################################################################
  // Future<Either<Failure, String>> login({
  //   required String password,
  //   required String userName,
  // }) async {
  //   try {
  //     var response = await api.post(
  //       endPoints: 'Provider/SignIn',
  //       data: {"password": password, "UserName": userName},
  //     );

  //     if (response.data['status'] == 'Success') {
  //       final token = response.data['token'];
  //       await _storage.write(key: 'token', value: token);
  //       await api.setAuthorizationHeader();

  //       // Fetch provider info after successful login
  //       var providerInfoResponse =
  //           await api.get(endpoint: 'Provider/GetProviderInfo');
  //       if (providerInfoResponse['status'] == 'Done') {
  //         List<dynamic> data = providerInfoResponse['data'];
  //         bool hasSelectedServices = data.isNotEmpty;

  //         if (hasSelectedServices) {
  //           // Fetch grooming types
  //           var groomingTypeResponse =
  //               await api.get(endpoint: 'Provider/getGroomingTypes');
  //           if (groomingTypeResponse['status'] == 'Success') {
  //             List<dynamic> groomingTypes =
  //                 groomingTypeResponse['groomingTypes'];

  //             // Cache grooming types
  //             await _storage.write(
  //                 key: 'groomingTypes', value: jsonEncode(groomingTypes));

  //             if (groomingTypes.isEmpty) {
  //               return right('Choose Services');
  //             } else {
  //               return right('Login Successful');
  //             }
  //           } else {
  //             return left(ServerFailure(groomingTypeResponse['status']));
  //           }
  //         } else {
  //           return right('Choose Services');
  //         }
  //       } else {
  //         return left(ServerFailure(providerInfoResponse['message']));
  //       }
  //     } else {
  //       return left(ServerFailure(response.data['message']));
  //     }
  //   } catch (e) {
  //     if (e is DioException) {
  //       return left(ServerFailure.fromDioError(e));
  //     }
  //     return left(ServerFailure(e.toString()));
  //   }
  // }

  Future<Either<Failure, String>> selectService({required String type}) async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.post(
        endPoints: 'Provider/SelectService',
        data: {"Type": type},
      );
      if (response.data['status'] == 'Success') {
        return right('Service added successfully');
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> updateProviderLocation({
    required double lat,
    required double long,
  }) async {
    try {
      await api.setAuthorizationHeader();
      var response = await api.put(
        endPoints: 'Provider/updateLocation',
        data: {"lat": lat, "long": long},
      );
      if (response.data['status'] == 'Success') {
        return right(response.data['message']);
      } else {
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
