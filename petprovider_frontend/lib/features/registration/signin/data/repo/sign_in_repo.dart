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
}
