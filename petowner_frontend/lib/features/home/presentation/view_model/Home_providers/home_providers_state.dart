part of 'home_providers_cubit.dart';

sealed class HomeProvidersState extends Equatable {
  const HomeProvidersState();

  @override
  List<Object> get props => [];
}

final class HomeProvidersInitial extends HomeProvidersState {}

final class HomeProvidersLoading extends HomeProvidersState {}

final class HomeProvidersFailure extends HomeProvidersState {
  final String errorMessage;

  const HomeProvidersFailure(this.errorMessage);
}

final class HomeProvidersSuccess extends HomeProvidersState {
  final List<Provider> providersList;

  const HomeProvidersSuccess({required this.providersList});
}

final class SortedProvidersLoading extends HomeProvidersState {}

final class SortedProvidersFailure extends HomeProvidersState {
  final String errorMessage;

  const SortedProvidersFailure({required this.errorMessage});
}

final class SortedProvidersSuccess extends HomeProvidersState {
  final List<ProviderSorted> providersList;

  const SortedProvidersSuccess({required this.providersList});
}

final class RecommendedProvidersLoading extends HomeProvidersState {}

final class RecommendedProvidersFailure extends HomeProvidersState {
  final String errorMessage;

  const RecommendedProvidersFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class RecommendedProvidersSuccess extends HomeProvidersState {
  final List<ProviderSorted> providersList;

  const RecommendedProvidersSuccess({required this.providersList});

  @override
  List<Object> get props => [providersList];
}
