part of 'grooming_cubit.dart';

abstract class GroomingState extends Equatable {
  const GroomingState();

  @override
  List<Object> get props => [];
}

class GroomingInitial extends GroomingState {}

class GroomingTypesUpdated extends GroomingState {
  final List<bool> selectedTypes;

  const GroomingTypesUpdated(this.selectedTypes);

  @override
  List<Object> get props => [selectedTypes];
}

class GroomingTypesLoading extends GroomingState {}

class GroomingTypesSuccess extends GroomingState {
  final String successMessage;

  const GroomingTypesSuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class GroomingTypesFailure extends GroomingState {
  final String errorMessage;

  const GroomingTypesFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
