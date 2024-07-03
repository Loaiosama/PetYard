import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/home/data/model/provider/provider.dart';
import 'package:petowner_frontend/features/home/data/model/provider_sorted/provider_sorted.dart';
import 'package:petowner_frontend/features/home/data/repo/home_repo.dart';

part 'home_providers_state.dart';

class HomeProvidersCubit extends Cubit<HomeProvidersState> {
  HomeProvidersCubit(this.homeRepo) : super(HomeProvidersInitial());

  final HomeRepo homeRepo;

  Future<void> getAllProvidersOfService({required String serviceName}) async {
    emit(HomeProvidersLoading());
    var result =
        await homeRepo.fetchAllProvidersOfService(serviceName: serviceName);

    result.fold(
      (failure) => emit(
        HomeProvidersFailure(failure.errorMessage),
      ),
      (providers) => emit(
        HomeProvidersSuccess(providersList: providers),
      ),
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
}
