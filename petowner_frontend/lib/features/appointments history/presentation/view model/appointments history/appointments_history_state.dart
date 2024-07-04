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

final class RejectedAppointmentLoading extends AppointmentsHistoryState {}

final class RejectedAppointmentSuccess extends AppointmentsHistoryState {
  final List<Rejectedmodel> rejectedReservations;

  const RejectedAppointmentSuccess({required this.rejectedReservations});
}

final class RejectedAppointmentFailure extends AppointmentsHistoryState {
  final String errorMessage;

  const RejectedAppointmentFailure({required this.errorMessage});
}

final class AcceptedAppointmentLoading extends AppointmentsHistoryState {}

final class AcceptedAppointmentSuccess extends AppointmentsHistoryState {
  final List<Acceptedmodel> acceptedReservations;

  const AcceptedAppointmentSuccess({required this.acceptedReservations});
}

final class AcceptedAppointmentFailure extends AppointmentsHistoryState {
  final String errorMessage;

  const AcceptedAppointmentFailure({required this.errorMessage});
}

final class AddRatingSuccess extends AppointmentsHistoryState {
  final bool isSuccess;

  const AddRatingSuccess({required this.isSuccess});
}

final class AddRatingLoading extends AppointmentsHistoryState {}

final class AddRatingFailure extends AppointmentsHistoryState {
  final String errorMessage;

  const AddRatingFailure({required this.errorMessage});
}
