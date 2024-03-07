import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  final baseUrl = 'http://localhost:3000/';

  Dio dio;

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
}
