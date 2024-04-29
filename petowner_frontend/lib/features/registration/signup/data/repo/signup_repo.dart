import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';

class SignUpRepo {
  final ApiService api;

  SignUpRepo({required this.api});

  Future<void> signUp({
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
      } else {
        // Handle error response
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      // Handle other errors
      debugPrint('sign up error: $e');
      rethrow;
    }
  }
}
