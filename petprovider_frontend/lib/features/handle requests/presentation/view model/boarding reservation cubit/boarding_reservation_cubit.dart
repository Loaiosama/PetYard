import 'package:bloc/bloc.dart';

import 'package:petprovider_frontend/features/handle%20requests/data/repo/boarding_repo/boarding_reservation_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/boarding%20reservation%20cubit/boarding_reservation_state.dart';

class BoardingReservationCubit extends Cubit<BoardingReservationState> {
  final BoardingReservationRepoImp repo;

  BoardingReservationCubit(this.repo) : super(BoardingReservationInitial());

  Future<void> fetchReservations() async {
    emit(BoardingReservationLoading());
    var eitherReservations = await repo.fetchReservations();
    eitherReservations.fold(
      (failure) => emit(BoardingReservationFailure(failure.errorMessage)),
      (reservations) => emit(BoardingReservationSuccess(reservations)),
    );
  }
}
