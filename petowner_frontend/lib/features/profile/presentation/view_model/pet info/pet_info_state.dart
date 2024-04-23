part of 'pet_info_cubit.dart';

sealed class PetInfoState extends Equatable {
  const PetInfoState();

  @override
  List<Object> get props => [];
}

final class PetInfoInitial extends PetInfoState {}

final class PetInfoLoading extends PetInfoState {}

final class PetInfoFailure extends PetInfoState {
  final String errorMessage;

  const PetInfoFailure(this.errorMessage);
}

class PetInfoSuccess extends PetInfoState {
  final AllPetsModel petModel;
  final int age;

  const PetInfoSuccess(this.petModel, this.age);
}
