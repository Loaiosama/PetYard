part of 'owner_info_cubit.dart';

sealed class OwnerInfoState extends Equatable {
  const OwnerInfoState();

  @override
  List<Object> get props => [];
}

final class OwnerInfoInitial extends OwnerInfoState {}

final class OwnerInfoLoading extends OwnerInfoState {}

final class OwnerInfoFailure extends OwnerInfoState {
  final String errorMessage;

  const OwnerInfoFailure({required this.errorMessage});
}

final class OwnerInfoSuccess extends OwnerInfoState {
  final OwnerInfo ownerInfo;

  const OwnerInfoSuccess({required this.ownerInfo});
}
