part of 'boarding_slots_cubit.dart';

sealed class BoardingSlotsState extends Equatable {
  const BoardingSlotsState();

  @override
  List<Object> get props => [];
}

final class BoardingSlotsInitial extends BoardingSlotsState {}

final class BoardingSlotsLoading extends BoardingSlotsState {}

final class BoardingSlotsFailure extends BoardingSlotsState {
  final String errorMessage;

  const BoardingSlotsFailure(this.errorMessage);
}

final class BoardingSlotsSuccess extends BoardingSlotsState {
  final ReserveServiceModel reserveServiceModel;

  const BoardingSlotsSuccess(this.reserveServiceModel);
}

final class BoardingSlotsUpdated extends BoardingSlotsState {
  final List<DateTime> activeDates;

  const BoardingSlotsUpdated(this.activeDates);

  @override
  List<Object> get props => [activeDates];
}

final class BoardingFeesDisplayLoading extends BoardingSlotsState {}

final class BoardingFeesDisplaySuccess extends BoardingSlotsState {
  final int finalCost;

  const BoardingFeesDisplaySuccess({required this.finalCost});
}

final class BoardingFeesDisplayFailure extends BoardingSlotsState {
  final String errorMessage;

  const BoardingFeesDisplayFailure(this.errorMessage);
}

final class ReserveSlotSuccess extends BoardingSlotsState {}

final class ReserveSlotLoading extends BoardingSlotsState {}

final class ReserveSlotFailure extends BoardingSlotsState {}
