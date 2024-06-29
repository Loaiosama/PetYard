part of 'grooming_service_cubit.dart';

sealed class GroomingServiceState extends Equatable {
  const GroomingServiceState();

  @override
  List<Object> get props => [];
}

final class GroomingServiceInitial extends GroomingServiceState {}

final class GroomingServiceLoading extends GroomingServiceState {}

final class GroomingServiceSuccess extends GroomingServiceState {
  final bool isSuccess;

  const GroomingServiceSuccess(this.isSuccess);

  @override
  List<Object> get props => [isSuccess];
}

final class GroomingServiceFailure extends GroomingServiceState {
  final String errorMessage;

  const GroomingServiceFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class GroomingServiceUpdated extends GroomingServiceState {
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final double slotLength;

  const GroomingServiceUpdated({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.slotLength,
  });

  @override
  List<Object> get props => [date, startTime, endTime, slotLength];
}

final class GroomingSlotLoading extends GroomingServiceState {}

final class GroomingSlotSuccess extends GroomingServiceState {
  final List<GroomingDatum> slots;

  const GroomingSlotSuccess({required this.slots});
}

final class GroomingSlotFailure extends GroomingServiceState {
  final String errorMessage;

  const GroomingSlotFailure({required this.errorMessage});
}
