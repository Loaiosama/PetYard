abstract class ApplyReservationState {}

class ApplyReservationInitial extends ApplyReservationState {}

class ApplyReservationLoading extends ApplyReservationState {}

class ApplyReservationSuccess extends ApplyReservationState {
  final String message;

  ApplyReservationSuccess(this.message);
}

class ApplyReservationFailure extends ApplyReservationState {
  final String error;

  ApplyReservationFailure(this.error);
}
