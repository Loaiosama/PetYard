import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';

class SignInRepo {
  final ApiService api;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SignInRepo({required this.api});

  Future<void> login({required String password, required String email}) async {
    try {
      var response = await api.post(
        endPoints: 'PetOwner/SignIn',
        data: {"password": password, "email": email},
      );
      // Check if response is successful
      if (response.data['status'] == 'Success') {
        final token = response.data['token'];
        await _storage.write(key: 'token', value: token);
        debugPrint(
            "=============================== ${response.data['status']}");
      } else {
        // Handle error response
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      // Handle other errors
      debugPrint('Login error: $e');
      rethrow;
    }
  }
}
