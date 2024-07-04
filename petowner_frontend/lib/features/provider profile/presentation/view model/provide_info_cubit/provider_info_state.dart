part of 'provider_info_cubit.dart';

sealed class ProviderInfoState extends Equatable {
  const ProviderInfoState();

  @override
  List<Object> get props => [];
}

final class ProviderInfoInitial extends ProviderInfoState {}

final class ProviderInfoLoading extends ProviderInfoState {}

final class ProviderInfoFailure extends ProviderInfoState {
  final String errorMessage;

  const ProviderInfoFailure(this.errorMessage);
}

class ProviderInfoSuccess extends ProviderInfoState {
  final ProviderInfoModel providerInfoModel;

  const ProviderInfoSuccess(this.providerInfoModel);
}

final class ProviderRatingLoading extends ProviderInfoState {}

final class ProviderRatingSuccess extends ProviderInfoState {
  final List<ProviderRating> providerRatings;

  const ProviderRatingSuccess({required this.providerRatings});
}

final class ProviderRatingFailure extends ProviderInfoState {
  final String errorMessage;

  const ProviderRatingFailure({required this.errorMessage});
}
