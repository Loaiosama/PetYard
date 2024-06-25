import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/appointments%20history/data/models/completedmodel/completedmodel.dart';
import 'package:petowner_frontend/features/appointments%20history/data/repo/appointments_history_repo.dart';

part 'appointments_history_state.dart';

class AppointmentsHistoryCubit extends Cubit<AppointmentsHistoryState> {
  AppointmentsHistoryCubit(this.appointmentHistoryRepo)
      : super(AppointmentsHistoryInitial());

  final AppointmentHistoryRepo appointmentHistoryRepo;

  Future fetchCompletedReservations() async {
    print('hello');
    emit(CompletedAppointmentsLoading());
    var result = await appointmentHistoryRepo.fetchCompletedReservations();
    result.fold(
        (failure) => emit(
            CompletedAppointmentsFailure(errorMessage: failure.toString())),
        (completed) => emit(
            CompletedAppointmentsSuccses(completedReservations: completed)));
  }
}
