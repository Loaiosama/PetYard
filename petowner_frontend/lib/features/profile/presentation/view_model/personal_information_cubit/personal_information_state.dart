part of 'personal_information_cubit.dart';

@immutable
sealed class PersonalInformationState {}

final class PersonalInformationInitial extends PersonalInformationState {}

final class PersonalInformationEditState extends PersonalInformationState {}

final class PersonalInformationEditGenderState
    extends PersonalInformationState {}
