import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/home/data/model/provider/provider.dart';
import 'package:petowner_frontend/features/home/data/model/provider_sorted/provider_sorted.dart';
import 'package:petowner_frontend/features/home/data/repo/home_repo.dart';

part 'home_providers_state.dart';

class HomeProvidersCubit extends Cubit<HomeProvidersState> {
  HomeProvidersCubit(this.homeRepo) : super(HomeProvidersInitial());

  final HomeRepo homeRepo;
  List<Provider> allProviders = [];
  List<Provider> filteredProviders = [];

  Future<void> getAllProvidersOfService({required String serviceName}) async {
    emit(HomeProvidersLoading());
    var result =
        await homeRepo.fetchAllProvidersOfService(serviceName: serviceName);

    result.fold(
      (failure) => emit(HomeProvidersFailure(failure.errorMessage)),
      (providers) {
        allProviders = providers;
        filteredProviders = providers;
        emit(HomeProvidersSuccess(providersList: providers));
      },
    );
  }

  Future<void> fetchProvidersSortedByRating(
      {required int rating, required String serviceName}) async {
    emit(SortedProvidersLoading());
    final response = await homeRepo.fetchProvidersSortedByRating(
        rating: rating, serviceName: serviceName);
    response.fold(
      (failure) =>
          emit(SortedProvidersFailure(errorMessage: failure.errorMessage)),
      (providersList) =>
          emit(SortedProvidersSuccess(providersList: providersList)),
    );
  }

  Future<void> fetchRecommendedProviders() async {
    emit(RecommendedProvidersLoading());
    final response = await homeRepo.fetchRecommendedProviders();
    response.fold(
      (failure) =>
          emit(RecommendedProvidersFailure(errorMessage: failure.errorMessage)),
      (providersList) =>
          emit(RecommendedProvidersSuccess(providersList: providersList)),
    );
  }

  void searchProviders(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all providers.
      filteredProviders = List.from(allProviders);
      emit(HomeProvidersSuccess(providersList: filteredProviders));
      return;
    }

    final searchLower = query.toLowerCase().trim();

    filteredProviders = allProviders.where((provider) {
      final username = provider.data?[0].username ?? '';
      final usernameLower = username.toLowerCase().trim();
      return usernameLower.contains(searchLower);
    }).toList();
    emit(HomeProvidersLoading());
    emit(HomeProvidersSuccess(providersList: filteredProviders));
  }
}
