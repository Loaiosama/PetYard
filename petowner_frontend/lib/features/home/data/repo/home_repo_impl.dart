// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/home/data/model/provider/datum.dart';
import 'package:petowner_frontend/features/home/data/model/provider/provider.dart';
import 'package:petowner_frontend/features/home/data/repo/home_repo.dart';
import 'package:petowner_frontend/features/home/data/model/provider_sorted/provider_sorted.dart';

class HomeRepoImpl extends HomeRepo {
  ApiService apiService;
  HomeRepoImpl({
    required this.apiService,
  });
  List<Provider> providersList = [];

  @override
  Future<Either<Failure, List<Provider>>> fetchAllProvidersOfService(
      {required String serviceName}) async {
    try {
      await apiService.setAuthorizationHeader();

      var response = await apiService.get(
          endpoint: 'PetOwner/GetProvidersByType/$serviceName');
      Provider providers = const Provider();
      // print(response['data']);
      // AllPetsModel allPetsModel = const AllPetsModel();
      for (var item in response['data']) {
        // print('item $item');
        var datum = Datum.fromJson(item);
        providers = Provider(
          status: response['status'],
          message: response['message'],
          data: [datum],
        );
        providersList.add(providers);
      }
      // print(allPetsModel.data![0].name);
      return right(providersList);
    } catch (e) {
      if (e is DioException) {
        // print('tagroba${ServerFailure.fromDioError(e)}');
        return left(ServerFailure.fromDioError(e));
      }
      // print('fail 2');
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProviderSorted>>> fetchProvidersSortedByRating(
      {required int rating, required String serviceName}) async {
    try {
      await apiService.setAuthorizationHeader();

      var response = await apiService.get(
          endpoint: 'PetOwner/FilterByRating/$rating/$serviceName');
      List<ProviderSorted> providersList = [];
      for (var item in response['data']) {
        providersList.add(ProviderSorted.fromJson(item));
      }
      return right(providersList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProviderSorted>>>
      fetchRecommendedProviders() async {
    try {
      await apiService.setAuthorizationHeader();

      var response =
          await apiService.get(endpoint: 'PetOwner/recomendedProviders');
      List<ProviderSorted> providersList = [];
      for (var item in response['data']) {
        providersList.add(ProviderSorted.fromJson(item));
      }
      return right(providersList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
