// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:petowner_frontend/features/grooming/data/models/grooming_pending_slots/grooming_pending_slots.dart';

abstract class GroomingServiceState extends Equatable {
  const GroomingServiceState();

  @override
  List<Object?> get props => [];
}

class GroomingServiceInitial extends GroomingServiceState {}

class GroomingDateSelected extends GroomingServiceState {
  final DateTime selectedDate;

  const GroomingDateSelected(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

class GroomingSlotSelected extends GroomingServiceState {
  final int selectedSlotIndex;

  const GroomingSlotSelected(this.selectedSlotIndex);

  @override
  List<Object?> get props => [selectedSlotIndex];
}

class GroomingTypeSelected extends GroomingServiceState {
  final int selectedGroomingTypeIndex;

  const GroomingTypeSelected(this.selectedGroomingTypeIndex);

  @override
  List<Object?> get props => [selectedGroomingTypeIndex];
}

class GroomingSlotsLoaded extends GroomingServiceState {
  final List<GroomingPendingSlots> groomingSlots;
  final List<DateTime> activeDates;
  final DateTime? selectedDate;
  final int selectedSlotIndex;
  final List<int> groomingTypeIndex;
  const GroomingSlotsLoaded(
    this.groomingSlots,
    this.activeDates,
    this.selectedDate,
    this.selectedSlotIndex,
    this.groomingTypeIndex,
  );

  @override
  List<Object?> get props => [
        groomingSlots,
        activeDates,
        selectedDate,
        selectedSlotIndex,
        groomingTypeIndex
      ];
}

class GroomingSlotsError extends GroomingServiceState {
  final String message;

  const GroomingSlotsError(this.message);

  @override
  List<Object?> get props => [message];
}

class GroomingSlotsLoading extends GroomingServiceState {}

final class ReserveSlotSuccess extends GroomingServiceState {}

final class ReserveSlotLoading extends GroomingServiceState {}

final class ReserveSlotFailure extends GroomingServiceState {}
