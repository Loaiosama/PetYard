import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:petprovider_frontend/features/grooming/data/models/grooming_slots/grooming_datum.dart';
import 'package:petprovider_frontend/features/grooming/data/repo/grooming_repo_impl.dart';

part 'grooming_service_state.dart';

class GroomingServiceCubit extends Cubit<GroomingServiceState> {
  GroomingServiceCubit(this.groomingRepoImpl) : super(GroomingServiceInitial());

  final TextEditingController slotLengthController =
      TextEditingController(text: '10 mins');
  final GroomingRepoImpl groomingRepoImpl;
  DateTime? selectedDate;
  DateTime? startTime;
  DateTime? endTime;
  double slotLength = 10.0;

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    // _emitUpdatedState();
  }

  void setStartTime(DateTime time) {
    startTime = time;
    combineDateTime(selectedDate ?? DateTime.now(), startTime!);
    // _emitUpdatedState();
  }

  void setEndTime(DateTime time) {
    endTime = time;

    // _emitUpdatedState();
  }

  void setSlotLength(double length) {
    slotLength = length;
    slotLengthController.text = length.toStringAsFixed(1);
    // _emitUpdatedState();
  }

  void incrementSlotLength() {
    setSlotLength(slotLength + 10);
  }

  void decrementSlotLength() {
    if (slotLength > 10) {
      setSlotLength(slotLength - 10);
    }
  }

  // void _emitUpdatedState() {
  //   if (selectedDate != null && startTime != null && endTime != null) {
  //     emit(GroomingServiceUpdated(
  //       date: selectedDate!,
  //       startTime: _combineDateTime(selectedDate!, startTime!),
  //       endTime: _combineDateTime(selectedDate!, endTime!),
  //       slotLength: slotLength,
  //     ));
  //   }
  // }

  DateTime combineDateTime(DateTime date, DateTime time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> createSlot({required int length}) async {
    if (selectedDate == null || startTime == null || endTime == null) {
      emit(const GroomingServiceFailure("All fields are required"));
      return;
    }
    startTime = combineDateTime(selectedDate!, startTime!);
    endTime = combineDateTime(selectedDate!, endTime!);

    emit(GroomingServiceLoading());
    // print(selectedDate);
    // print(startTime);
    // print(endTime);
    // print(slotLength);
    // print(slotLengthController.text);

    await Future.delayed(const Duration(seconds: 1));
    var result = await groomingRepoImpl.createGroomingSlot(
        startdate: startTime!, enddate: endTime!, length: length);
    result.fold((failure) => emit(GroomingServiceFailure(failure.errorMessage)),
        (success) => emit(GroomingServiceSuccess(success)));
  }

  @override
  Future<void> close() {
    slotLengthController.dispose();
    return super.close();
  }

  Future<void> fetchProviderSlots() async {
    emit(GroomingSlotLoading());
    var result = await groomingRepoImpl.getGroomingSlots();
    result.fold(
      (failue) => emit(GroomingSlotFailure(errorMessage: failue.errorMessage)),
      (slots) => emit(
        GroomingSlotSuccess(
          slots: slots,
        ),
      ),
    );
  }
  // Future<void> getSlots() {}
}
