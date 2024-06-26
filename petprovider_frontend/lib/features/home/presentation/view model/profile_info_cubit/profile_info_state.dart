part of 'profile_info_cubit.dart';

sealed class ProfileInfoState extends Equatable {
  const ProfileInfoState();

  @override
  List<Object> get props => [];
}

final class ProfileInfoInitial extends ProfileInfoState {}

final class ProfileInfoLoading extends ProfileInfoState {}

final class ProfileInfoSuccess extends ProfileInfoState {
  final ProfileInfo profileInfo;

  const ProfileInfoSuccess({required this.profileInfo});
}

final class ProfileInfoFailure extends ProfileInfoState {
  final String errorMessage;

  const ProfileInfoFailure({required this.errorMessage});
}

final class ProviderSlotLoading extends ProfileInfoState {}

final class ProviderSlotSuccess extends ProfileInfoState {
  final List<ProviderSlotData> slots;

  const ProviderSlotSuccess({required this.slots});
}

final class ProviderSlotFailure extends ProfileInfoState {
  final String errorMessage;

  const ProviderSlotFailure({required this.errorMessage});
}

final class DeleteSlotSuccess extends ProfileInfoState {
  final bool isSuccess;

  const DeleteSlotSuccess({required this.isSuccess});
}

final class DeleteSlotFailure extends ProfileInfoState {
  final String isSuccess;

  const DeleteSlotFailure({required this.isSuccess});
}
