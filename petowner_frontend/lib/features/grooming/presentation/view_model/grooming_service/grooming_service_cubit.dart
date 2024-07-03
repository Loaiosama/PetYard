import 'package:bloc/bloc.dart';
import 'package:petowner_frontend/features/grooming/data/models/grooming_pending_slots/grooming_pending_slots.dart';
import 'package:petowner_frontend/features/grooming/data/repo/grooming_repo.dart';
import 'grooming_service_state.dart';

class GroomingServiceCubit extends Cubit<GroomingServiceState> {
  GroomingServiceCubit(this.groomingRepo) : super(GroomingServiceInitial());
  DateTime? selectedDate;
  int? selectedSlotIndex;
  int? selectedGroomingTypeIndex;
  final GroomingRepo groomingRepo;
  List<int> selectedGroomingTypeIndices = [];
  List types = ['Bathing', 'Fur Trimming', 'Nail Trimming', 'Full Package'];
  // void selectDate(DateTime date) {
  //   selectedDate = date;
  //   emit(GroomingDateSelected(date));
  // }
  int selectedPet = -1;
  String selectedPetname = '';
  void selectPet(int id, String name) {
    selectedPet = id;
    selectedPetname = name;
  }

  void selectSlot(int index) {
    selectedSlotIndex = index;
    // emit(GroomingSlotSelected(index));
    emit(GroomingSlotsLoaded(
      (state as GroomingSlotsLoaded).groomingSlots,
      (state as GroomingSlotsLoaded).activeDates,
      selectedDate,
      selectedSlotIndex ?? -1,
      selectedGroomingTypeIndices,
    ));
  }

  void toggleGroomingType(int index) {
    if (selectedGroomingTypeIndices.contains(index)) {
      selectedGroomingTypeIndices.remove(index);
    } else {
      selectedGroomingTypeIndices.add(index);
    }
    print(selectedGroomingTypeIndices);
    print('object');
    emit(GroomingSlotsLoaded(
      (state as GroomingSlotsLoaded).groomingSlots,
      (state as GroomingSlotsLoaded).activeDates,
      selectedDate,
      selectedSlotIndex ?? -1,
      List.from(selectedGroomingTypeIndices), // Ensure a new list is emitted
    ));
  }

  void selectGroomingType(int index) {
    selectedGroomingTypeIndex = index;
    print("Selected Grooming Type Index: $selectedGroomingTypeIndex");
    if (state is GroomingSlotsLoaded) {
      emit(GroomingSlotsLoaded(
        (state as GroomingSlotsLoaded).groomingSlots,
        (state as GroomingSlotsLoaded).activeDates,
        selectedDate,
        selectedSlotIndex ?? -1,
        selectedGroomingTypeIndices,
      ));
    }
  }

  bool isGroomingTypeSelected(int index) {
    return selectedGroomingTypeIndices.contains(index);
  }
  // bool isGroomingTypeSelected(int index) {
  //   print(
  //       "Checking if Grooming Type is Selected: $index == $selectedGroomingTypeIndex");
  //   print(selectedGroomingTypeIndex == index);
  //   return selectedGroomingTypeIndex == index;
  // }

  bool isSlotSelected(int index) {
    // print(index);
    return selectedSlotIndex == index;
  }

  // bool isGroomingTypeSelected(int index) {
  //   return selectedGroomingTypeIndex == index;
  // }

  // Future<void> fetchGroomingSlots(int providerId) async {
  //   emit(GroomingSlotsLoading());
  //   var result =
  //       await groomingRepo.groomingPendingSlots(providerId: providerId);

  //   result.fold(
  //     (failure) => emit(GroomingSlotsError(_mapFailureToMessage(failure))),
  //     (slots) {
  //       final activeDates = _extractActiveDates(slots);
  //       emit(GroomingSlotsLoaded(slots, activeDates));
  //     },
  //   );
  // }

  // List<DateTime> _extractActiveDates(List<GroomingPendingSlots> slots) {
  //   final activeDates = <DateTime>{};
  //   for (var slot in slots) {
  //     for (var datum in slot.data!) {
  //       activeDates.add(DateTime(
  //         datum.startTime!.year,
  //         datum.startTime!.month,
  //         datum.startTime!.day,
  //       ));
  //     }
  //   }
  //   return activeDates.toList()..sort();
  // }

  // String _mapFailureToMessage(Failure failure) {
  //   switch (failure.runtimeType) {
  //     case ServerFailure _:
  //       return 'Server Failure';
  //     default:
  //       return 'Unexpected Error';
  //   }
  // }
  void selectDate(DateTime date) {
    selectedDate = date;
    if (state is GroomingSlotsLoaded) {
      emit(GroomingSlotsLoaded(
        (state as GroomingSlotsLoaded).groomingSlots,
        (state as GroomingSlotsLoaded).activeDates,
        selectedDate,
        selectedSlotIndex ?? -1,
        selectedGroomingTypeIndices,
      ));
    }
  }

  // void selectSlot(int index) {
  //   selectedSlotIndex = index;
  //   emit(GroomingSlotSelected(index));
  // }

  // void selectGroomingType(int index) {
  //   selectedGroomingTypeIndex = index;
  //   emit(GroomingTypeSelected(index));
  // }

  // bool isSlotSelected(int index) {
  //   return selectedSlotIndex == index;
  // }

  // bool isGroomingTypeSelected(int index) {
  //   return selectedGroomingTypeIndex == index;
  // }

  Future<void> fetchGroomingSlots(int providerId) async {
    emit(GroomingSlotsLoading());
    var result =
        await groomingRepo.groomingPendingSlots(providerId: providerId);

    result.fold(
      (failure) => emit(GroomingSlotsError(failure.errorMessage)),
      (slots) {
        final activeDates = _extractActiveDates(slots);
        emit(GroomingSlotsLoaded(
          slots,
          activeDates,
          selectedDate,
          selectedSlotIndex ?? -1,
          selectedGroomingTypeIndices,
        ));
      },
    );
  }

  List<DateTime> _extractActiveDates(List<GroomingPendingSlots> slots) {
    final activeDates = <DateTime>{};
    for (var slot in slots) {
      for (var datum in slot.data!) {
        activeDates.add(DateTime(
          datum.startTime!.year,
          datum.startTime!.month,
          datum.startTime!.day,
        ));
      }
    }
    return activeDates.toList()..sort();
  }

  Future<void> reserveGroomingSlot({
    required int slotID,
    required int petID,
    required List groomingTypes,
  }) async {
    emit(ReserveSlotLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      bool result = await groomingRepo.reserveGroomingSlot(
          slotID: slotID, petID: petID, groomingTypes: groomingTypes);
      if (result) {
        emit(ReserveSlotSuccess());
      } else {
        emit(ReserveSlotFailure());
      }
    } catch (e) {
      emit(ReserveSlotFailure());
    }
  }
}
