import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/Pet.dart';

sealed class PetInfoState extends Equatable {
  const PetInfoState();
  @override
  List<Object> get props => [];
}

final class PetInfoInitial extends PetInfoState {}

final class PetInfoLoading extends PetInfoState {}

final class PetInfoSuccess extends PetInfoState {
  final Pet pet;
  final int age;
  const PetInfoSuccess(this.pet, this.age);
}

final class PetInfofaliure extends PetInfoState {
  final String errorMessage;
  const PetInfofaliure(this.errorMessage);
}
