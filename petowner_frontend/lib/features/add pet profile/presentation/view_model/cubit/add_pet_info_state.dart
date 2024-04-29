part of 'add_pet_info_cubit.dart';

@immutable
sealed class AddPetInfoState {}

final class AddPetInfoInitial extends AddPetInfoState {}

final class AddPetInfoSuccess extends AddPetInfoState {
  final String successMessage;

  AddPetInfoSuccess({required this.successMessage});
}

final class AddPetInfoFaliure extends AddPetInfoState {
  final String errorMessage;

  AddPetInfoFaliure({required this.errorMessage});
}

final class AddPetInfoloading extends AddPetInfoState {}
