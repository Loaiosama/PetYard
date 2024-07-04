part of 'active_pets_cubit_cubit.dart';

sealed class ActivePetsCubitState extends Equatable {
  const ActivePetsCubitState();

  @override
  List<Object> get props => [];
}

final class ActivePetsCubitInitial extends ActivePetsCubitState {}

final class ActivePetsCubitLoading extends ActivePetsCubitState {}

final class ActivePetsCubitFailure extends ActivePetsCubitState {
  final String errorMessage;

  const ActivePetsCubitFailure(this.errorMessage);
}

final class ActivePetsCubitSuccess extends ActivePetsCubitState {
  final List<AllPetsModel> allPets;

  const ActivePetsCubitSuccess(this.allPets);
}
