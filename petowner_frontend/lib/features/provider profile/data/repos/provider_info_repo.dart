// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/provider%20profile/data/models/provider_info_model/provider_info_model.dart';
import 'package:petowner_frontend/features/provider%20profile/data/models/provider_rating.dart';

class ProviderInfoRepo {
  ApiService apiService;
  ProviderInfoRepo({
    required this.apiService,
  });

  Future<Either<Failure, ProviderInfoModel>> getProviderInfo(
      {required int id}) async {
    try {
      await apiService.setAuthorizationHeader();
      var response =
          await apiService.get(endpoint: 'PetOwner/GetProviderInfo/$id');

      // Check if the response contains an error status
      if (response['status'] != null && response['status'] == 'error') {
        return left(ServerFailure(response['message'].toString()));
      }

      // Parse the response into ProviderInfoModel
      var providerInfo = ProviderInfoModel.fromJson(response);
      // print(providerInfo.data!.username);
      return right(providerInfo);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ProviderRating>>> fetchProviderRatings(
      {required int provideriD}) async {
    try {
      await apiService.setAuthorizationHeader();
      var response = await apiService.get(
          endpoint: 'PetOwner/GetAllReviewsForSpecificProvider/$provideriD');

      if (response['status'] == 'Success') {
        var ratings = (response['data'] as List)
            .map((rating) => ProviderRating.fromJson(rating))
            .toList();
        return right(ratings);
      } else {
        return left(ServerFailure(response['message'].toString()));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
