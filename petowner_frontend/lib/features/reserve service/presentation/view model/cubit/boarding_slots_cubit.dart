import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/reserve%20service/data/models/reserve_service_model/reserve_service_model.dart';
import 'package:petowner_frontend/features/reserve%20service/data/models/reserve_service_model/reserved_slots.dart';
import 'package:petowner_frontend/features/reserve%20service/data/repo/reserve_service_repo.dart';

import '../../../data/models/reserve_service_model/slots.dart';

part 'boarding_slots_state.dart';

class BoardingSlotsCubit extends Cubit<BoardingSlotsState> {
  BoardingSlotsCubit(this.reserveServiceRepo) : super(BoardingSlotsInitial());
  final ReserveServiceRepo reserveServiceRepo;

  Future<void> reserveSlot({
    required DateTime startDate,
    required DateTime endDate,
    required int slotID,
    required int petID,
  }) async {
    emit(ReserveSlotLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      bool result = await reserveServiceRepo.reserveSlot(
          startDate: startDate, endDate: endDate, slotID: slotID, petID: petID);
      if (result) {
        emit(ReserveSlotSuccess());
      } else {
        emit(ReserveSlotFailure());
      }
    } catch (e) {
      emit(ReserveSlotFailure());
    }
  }

  Future feesDisplay(
      {required DateTime startDate,
      required DateTime endDate,
      required int slotID}) async {
    // print('object');
    emit(BoardingFeesDisplayLoading());
    var result = await reserveServiceRepo.feesDisplay(
        startDate: startDate, endDate: endDate, slotID: slotID);
    result.fold(
        (failure) => emit(BoardingFeesDisplayFailure(failure.errorMessage)),
        (fees) => emit(BoardingFeesDisplaySuccess(finalCost: fees)));
  }

  Future<void> getFreeSlots({required int providerId}) async {
    emit(BoardingSlotsLoading());
    var result =
        await reserveServiceRepo.fetchBoardingSlots(providerId: providerId);

    result.fold(
      (failure) => emit(BoardingSlotsFailure(failure.errorMessage)),
      (reserveService) {
        emit(BoardingSlotsSuccess(reserveService));
        calculateFreeSlots(reserveService);
      },
    );
  }

  void calculateFreeSlots(ReserveServiceModel reserveService) {
    // Extract free and reserved slots from the ReserveServiceModel
    List<Slots> freeSlots = reserveService.data ?? [];
    List<ReservedSlots> reservedSlots = reserveService.data1 ?? [];

    List<DateTime> activeDates = [];

    for (var slot in freeSlots) {
      DateTime startDate = slot.startTime!;
      DateTime endDate = slot.endTime!;

      for (var date = startDate;
          date.isBefore(endDate.add(const Duration(days: 1)));
          date = date.add(const Duration(days: 1))) {
        // Check if the date falls within any reserved slot
        bool isReserved = reservedSlots.any((reserve) {
          DateTime reserveStartDate = reserve.startTime!;
          DateTime reserveEndDate = reserve.endTime!;
          return date.isAfter(
                  reserveStartDate.subtract(const Duration(days: 1))) &&
              date.isBefore(reserveEndDate.add(const Duration(days: 1)));
        });

        // Add the date to activeDates if it's not reserved
        if (!isReserved) {
          activeDates.add(date);
        }
      }
    }

    // Remove duplicates from activeDates
    activeDates = activeDates.toSet().toList();

    // Emit updated state with activeDates
    emit(BoardingSlotsUpdated(activeDates));
  }
}
