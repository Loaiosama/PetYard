part of 'upcoming_events_cubit.dart';

sealed class UpcomingEventsState extends Equatable {
  const UpcomingEventsState();

  @override
  List<Object> get props => [];
}

final class UpcomingEventsInitial extends UpcomingEventsState {}

class UpcomingEventsLoading extends UpcomingEventsState {}

class UpcomingEventsSuccess extends UpcomingEventsState {
  final List<UpcomingDatum> upcomingEvents;

  const UpcomingEventsSuccess(this.upcomingEvents);
}

class UpcomingEventsFailure extends UpcomingEventsState {
  final String errorMessage;

  const UpcomingEventsFailure({required this.errorMessage});
}
