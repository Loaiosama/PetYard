import 'package:bloc/bloc.dart';

import 'package:petprovider_frontend/features/handle%20requests/data/model/reservation_update.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/boarding_repo/boarding_reservation_repo.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/update%20reservation%20cubit/update_reservation_state.dart';

class ApplyReservationCubit extends Cubit<ApplyReservationState> {
  final BoardingReservationRepo repository;

  ApplyReservationCubit(this.repository) : super(ApplyReservationInitial());

  Future<void> applyReservation(
      int reservId, ReservationUpdate reservationUpdate) async {
    emit(ApplyReservationLoading());

    final result =
        await repository.updateRservation(reservId, reservationUpdate);

    result.fold(
      (failure) => emit(ApplyReservationFailure(failure.toString())),
      (message) => emit(ApplyReservationSuccess(message)),
    );
  }
}
