part of 'personal_information_cubit.dart';

@immutable
sealed class PersonalInformationState {}

final class PersonalInformationInitial extends PersonalInformationState {}

final class PersonalInformationEditState extends PersonalInformationState {}

final class PersonalInformationEditGenderState
    extends PersonalInformationState {}

final class PersonalInformationLoadedState extends PersonalInformationState {}

final class PersonalInformationDateSelectedState
    extends PersonalInformationState {}

final class UpdateOwnerInformationLoading extends PersonalInformationState {}

final class UpdateOwnerInformationSuccess extends PersonalInformationState {
  final bool isSuccess;

  UpdateOwnerInformationSuccess({required this.isSuccess});
}

final class UpdateOwnerInformationFailure extends PersonalInformationState {
  final bool isFail;

  UpdateOwnerInformationFailure({required this.isFail});
}
