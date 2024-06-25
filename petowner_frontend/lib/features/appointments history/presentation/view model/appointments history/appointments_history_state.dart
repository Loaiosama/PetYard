part of 'appointments_history_cubit.dart';

sealed class AppointmentsHistoryState extends Equatable {
  const AppointmentsHistoryState();

  @override
  List<Object> get props => [];
}

final class AppointmentsHistoryInitial extends AppointmentsHistoryState {}

final class CompletedAppointmentsLoading extends AppointmentsHistoryState {}

final class CompletedAppointmentsFailure extends AppointmentsHistoryState {
  final String errorMessage;

  const CompletedAppointmentsFailure({required this.errorMessage});
}

final class CompletedAppointmentsSuccses extends AppointmentsHistoryState {
  final List<Completedmodel> completedReservations;

  const CompletedAppointmentsSuccses({required this.completedReservations});
}

final class PendingAppointmentLoading extends AppointmentsHistoryState {}

final class PendingAppointmentSuccess extends AppointmentsHistoryState {
  final List<Pendingmodel> pendingReservations;

  const PendingAppointmentSuccess({required this.pendingReservations});
}

final class PendingAppointmentFailure extends AppointmentsHistoryState {
  final String errorMessage;

  const PendingAppointmentFailure({required this.errorMessage});
}
