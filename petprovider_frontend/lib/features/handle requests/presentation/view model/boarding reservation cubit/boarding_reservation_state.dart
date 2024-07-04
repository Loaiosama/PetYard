import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/boarding_reservation.dart';

abstract class BoardingReservationState extends Equatable {
  const BoardingReservationState();

  @override
  List<Object> get props => [];
}

class BoardingReservationInitial extends BoardingReservationState {}

class BoardingReservationLoading extends BoardingReservationState {}

class BoardingReservationSuccess extends BoardingReservationState {
  final List<BoardingReservation> reservations;

  const BoardingReservationSuccess(this.reservations);
}

class BoardingReservationFailure extends BoardingReservationState {
  final String message;

  const BoardingReservationFailure(this.message);
}
