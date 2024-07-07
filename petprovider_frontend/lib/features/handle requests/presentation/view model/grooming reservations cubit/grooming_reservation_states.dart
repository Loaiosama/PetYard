import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/grooming%20reservation';

abstract class GroomingReservationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroomingReservationInitial extends GroomingReservationState {}

class GroomingReservationLoading extends GroomingReservationState {}

class GroomingReservationSucsses extends GroomingReservationState {
  final List<GroomingReservation> reservations;

  GroomingReservationSucsses(this.reservations);
}

class GroomingReservationFailure extends GroomingReservationState {
  final String message;

  GroomingReservationFailure(this.message);
}
