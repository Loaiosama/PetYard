import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final baseUrl = 'http://192.168.1.3:3000/';

  Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService({
    required this.dio,
  });

  var headers = {'Content-Type': 'application/json'};

  Future<Response> post(
      {required String endPoints, required Map<String, dynamic> data}) async {
    try {
      var response = await dio.post(
        '$baseUrl$endPoints',
        data: data,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
      );
      return response;
    } catch (error) {
      debugPrint('Login error: $error');
      rethrow; // Re-throw the error for handling in the caller
    }
  }

  // Future<Response> login() async {
  //   try {
  //     var response = await dio.post(
  //       'http://192.168.1.3:3000/PetOwner/SignIn',
  //       data: {"password": "1234", "email": "yaya@example.com"},
  //       options: Options(
  //         method: 'POST',
  //         headers: headers,
  //       ),
  //     );
  //     print('response codeee ${response.statusCode}');
  //     if (response.data['status'] == 'Success') {
  //       final token = response.data['token'];
  //       await _storage.write(key: 'token', value: token);
  //       debugPrint("fsdfnlksadjflndaskfnklsadnmkl ${response.data['status']}");
  //     } else if (response.statusCode == 401) {
  //       debugPrint('Incorrect email or password');
  //     } else {
  //       // Handle error response
  //       debugPrint('=================Incorrect email or password');
  //       throw Exception('Failed to sign in');
  //     }
  //     return response;
  //   } catch (error) {
  //     // just for now
  //     debugPrint('=================Incorrect email or password');
  //     // debugPrint('Login error: $error');
  //     rethrow; // Re-throw the error for handling in the caller
  //   }
  // }
}
