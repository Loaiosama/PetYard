part of 'grooming_types_cubit.dart';

sealed class GroomingTypesState extends Equatable {
  const GroomingTypesState();

  @override
  List<Object> get props => [];
}

final class GroomingTypesInitial extends GroomingTypesState {}

class GroomingTypesLoading extends GroomingTypesState {}

class GroomingTypesLoaded extends GroomingTypesState {
  final List<String> types;

  const GroomingTypesLoaded(this.types);

  @override
  List<Object> get props => [types];
}

class GroomingTypesError extends GroomingTypesState {
  final String message;

  const GroomingTypesError(this.message);

  @override
  List<Object> get props => [message];
}
