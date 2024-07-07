import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/grooming%20reservation';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/grooming%20repo/grooming_repo.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/grooming%20repo/grooming_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/grooming%20reservations%20cubit/grooming_reservation_states.dart';

class GroomingReservationCubit extends Cubit<GroomingReservationState> {
  final GroomingRepo groomingRepo;

  GroomingReservationCubit(this.groomingRepo)
      : super(GroomingReservationInitial());

  Future<void> fetchGroomingReservations() async {
    emit(GroomingReservationLoading());
    Either<Failure, List<GroomingReservation>> response =
        await groomingRepo.getGroomingReservations();

    response.fold(
      (failure) => emit(GroomingReservationFailure(failure.errorMessage)),
      (reservations) => emit(GroomingReservationSucsses(reservations)),
    );
  }
}
