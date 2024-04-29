import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/home/data/model/provider/provider.dart';
import 'package:petowner_frontend/features/home/data/repo/home_repo.dart';

part 'home_providers_state.dart';

class HomeProvidersCubit extends Cubit<HomeProvidersState> {
  HomeProvidersCubit(this.homeRepo) : super(HomeProvidersInitial());

  final HomeRepo homeRepo;

  Future<void> getAllProvidersOfService() async {
    emit(HomeProvidersLoading());
    var result = await homeRepo.fetchAllProvidersOfService();

    result.fold(
      (failure) => emit(
        HomeProvidersFailure(failure.errorMessage),
      ),
      (providers) => emit(
        HomeProvidersSuccess(providersList: providers),
      ),
    );
  }
}
