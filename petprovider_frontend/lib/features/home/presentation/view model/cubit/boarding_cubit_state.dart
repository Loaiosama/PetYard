part of 'boarding_cubit_cubit.dart';

sealed class BoardingCubitState extends Equatable {
  const BoardingCubitState();

  @override
  List<Object> get props => [];
}

final class BoardingCubitInitial extends BoardingCubitState {}

class BoardingSlotLoading extends BoardingCubitState {}

class BoardingSlotSuccess extends BoardingCubitState {}

class BoardingSlotFailure extends BoardingCubitState {
  final String errorMessage;

  const BoardingSlotFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
