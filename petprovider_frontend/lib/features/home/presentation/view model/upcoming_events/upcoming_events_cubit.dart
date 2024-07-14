import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/home/data/models/upcoming_events/upcoming_datum.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo.dart';

part 'upcoming_events_state.dart';

class UpcomingEventsCubit extends Cubit<UpcomingEventsState> {
  UpcomingEventsCubit(this.homeRepo) : super(UpcomingEventsInitial());
  final HomeRepo homeRepo;

  void fetchUpcomingEvents() async {
    emit(UpcomingEventsLoading());
    final result = await homeRepo.fetchUpcomingEvents();
    result.fold(
      (failure) =>
          emit(UpcomingEventsFailure(errorMessage: failure.errorMessage)),
      (events) => emit(UpcomingEventsSuccess(events)),
    );
  }
}
