part of 'history_cubit.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

final class HistoryInitial extends HistoryState {}

final class AppointmentsHistoryInitial extends HistoryState {}

final class CompletedAppointmentsLoading extends HistoryState {}

final class CompletedAppointmentsFailure extends HistoryState {
  final String errorMessage;

  const CompletedAppointmentsFailure({required this.errorMessage});
}

final class CompletedAppointmentsSuccses extends HistoryState {
  final List<Completedmodel> completedReservations;

  const CompletedAppointmentsSuccses({required this.completedReservations});
}

final class PendingAppointmentLoading extends HistoryState {}

final class PendingAppointmentSuccess extends HistoryState {
  final List<Pendingmodel> pendingReservations;

  const PendingAppointmentSuccess({required this.pendingReservations});
}

final class PendingAppointmentFailure extends HistoryState {
  final String errorMessage;

  const PendingAppointmentFailure({required this.errorMessage});
}

final class RejectedAppointmentLoading extends HistoryState {}

final class RejectedAppointmentSuccess extends HistoryState {
  final List<Rejectedmodel> rejectedReservations;

  const RejectedAppointmentSuccess({required this.rejectedReservations});
}

final class RejectedAppointmentFailure extends HistoryState {
  final String errorMessage;

  const RejectedAppointmentFailure({required this.errorMessage});
}
