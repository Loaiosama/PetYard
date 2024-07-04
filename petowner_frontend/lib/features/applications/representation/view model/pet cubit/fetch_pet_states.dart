import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/applications/data/model/Pet.dart';

sealed class FetchPetState extends Equatable {
  const FetchPetState();
  @override
  List<Object> get props => [];
}

final class FetchPetInitial extends FetchPetState {}

final class FetchPetLoading extends FetchPetState {}

final class FetchPetSuccess extends FetchPetState {
  final Pet pet;

  const FetchPetSuccess(this.pet);
}

final class FetchPetFailure extends FetchPetState {
  final String errorMessage;
  const FetchPetFailure(this.errorMessage);
}
