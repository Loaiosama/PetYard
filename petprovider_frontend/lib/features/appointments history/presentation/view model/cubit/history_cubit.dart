import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/completedmodel/completedmodel.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/pendingmodel/pendingmodel.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/models/rejectedmodel/rejectedmodel.dart';
import 'package:petprovider_frontend/features/appointments%20history/data/repo/appointments_history_repo.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this.appointmentHistoryRepo) : super(HistoryInitial());
  final AppointmentHistoryRepo appointmentHistoryRepo;

  Future fetchCompletedReservations() async {
    emit(CompletedAppointmentsLoading());
    var result = await appointmentHistoryRepo.fetchCompletedReservations();
    result.fold(
        (failure) => emit(
            CompletedAppointmentsFailure(errorMessage: failure.errorMessage)),
        (completed) => emit(
            CompletedAppointmentsSuccses(completedReservations: completed)));
  }

  Future fetchPendingReservations() async {
    emit(PendingAppointmentLoading());
    var result = await appointmentHistoryRepo.fetchPendingReservations();
    result.fold(
        (failure) =>
            emit(PendingAppointmentFailure(errorMessage: failure.errorMessage)),
        (pending) =>
            emit(PendingAppointmentSuccess(pendingReservations: pending)));
  }

  Future fetchRejectedReservations() async {
    emit(RejectedAppointmentLoading());
    var result = await appointmentHistoryRepo.fetchRejectedReservations();
    result.fold(
        (failure) => emit(
            RejectedAppointmentFailure(errorMessage: failure.errorMessage)),
        (rejected) =>
            emit(RejectedAppointmentSuccess(rejectedReservations: rejected)));
  }
}
