import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/appointments%20history/data/models/acceptedmodel/acceptedmodel.dart';
import 'package:petowner_frontend/features/appointments%20history/data/models/completedmodel/completedmodel.dart';
import 'package:petowner_frontend/features/appointments%20history/data/models/pendingmodel/pendingmodel.dart';
import 'package:petowner_frontend/features/appointments%20history/data/models/rejectedmodel/rejectedmodel.dart';
import 'package:petowner_frontend/features/appointments%20history/data/repo/appointments_history_repo.dart';
part 'appointments_history_state.dart';

class AppointmentsHistoryCubit extends Cubit<AppointmentsHistoryState> {
  AppointmentsHistoryCubit(this.appointmentHistoryRepo)
      : super(AppointmentsHistoryInitial());

  final AppointmentHistoryRepo appointmentHistoryRepo;

  Future fetchCompletedReservations() async {
    emit(CompletedAppointmentsLoading());
    var result = await appointmentHistoryRepo.fetchCompletedReservations();
    result.fold(
        (failure) => emit(
            CompletedAppointmentsFailure(errorMessage: failure.toString())),
        (completed) => emit(
            CompletedAppointmentsSuccses(completedReservations: completed)));
  }

  Future fetchPendingReservations() async {
    emit(PendingAppointmentLoading());
    var result = await appointmentHistoryRepo.fetchPendingReservations();
    result.fold(
        (failure) =>
            emit(PendingAppointmentFailure(errorMessage: failure.toString())),
        (pending) =>
            emit(PendingAppointmentSuccess(pendingReservations: pending)));
  }

  Future fetchRejectedReservations() async {
    emit(RejectedAppointmentLoading());
    var result = await appointmentHistoryRepo.fetchRejectedReservations();
    result.fold(
        (failure) =>
            emit(RejectedAppointmentFailure(errorMessage: failure.toString())),
        (rejected) =>
            emit(RejectedAppointmentSuccess(rejectedReservations: rejected)));
  }

  Future fetchAcceptedReservations() async {
    emit(AcceptedAppointmentLoading());
    var result = await appointmentHistoryRepo.fetchAcceptedReservations();
    result.fold(
        (failure) =>
            emit(AcceptedAppointmentFailure(errorMessage: failure.toString())),
        (accepted) =>
            emit(AcceptedAppointmentSuccess(acceptedReservations: accepted)));
  }

  Future addRatingAndReview(
      {required int providerId,
      required double rate,
      required String review}) async {
    emit(AddRatingLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    var result = await appointmentHistoryRepo.addRatingAndReview(
        providerId: providerId, rate: rate, review: review);
    result.fold(
        (failure) => emit(AddRatingFailure(errorMessage: failure.errorMessage)),
        (success) => emit(AddRatingSuccess(isSuccess: success)));
  }
}
