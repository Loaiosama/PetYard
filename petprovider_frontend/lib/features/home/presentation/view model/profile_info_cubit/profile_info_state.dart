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
