import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/pet%20profile/data/pet_model.dart';
import 'package:petowner_frontend/features/pet%20profile/data/repos/pet_info_repo.dart';

class PetInfoRepoImp extends PetInfoRepo
{

  final ApiService apiService ;
   final FlutterSecureStorage _storage = const FlutterSecureStorage();

  PetInfoRepoImp({required this.apiService}); 
  @override
  Future<void> addPetInfo({required PetModel petModel}) async {
    try {
      var response = await apiService.post(
        endPoints: 'PetOwner/SignIn',
        data: petModel.toJson() ,
      );
      // Check if response is successful
      if (response.data['status'] == 'Success') {
        final token = response.data['token'];
        await _storage.write(key: 'token', value: token);
        debugPrint(
            "=============================== ${response.data['status']}");
      } else {
        // Handle error response
        throw Exception('Failed to add pet');
      }
    } catch (e) {
      // Handle other errors
      debugPrint('add pet error error: $e');
      rethrow;
    }
    
  
  }

  @override
  Future<List<PetModel>> fetchPetInfo() {
    // TODO: implement fetchPetInfo
    throw UnimplementedError();
  }
  
}