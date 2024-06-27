import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo.dart';

part 'boarding_cubit_state.dart';

class BoardingCubitCubit extends Cubit<BoardingCubitState> {
  BoardingCubitCubit(this.homeRepo) : super(BoardingCubitInitial());

  final HomeRepo homeRepo;

  double price = 0.0;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController priceController = TextEditingController();
  void setPrice(double newPrice) {
    price = newPrice;
  }

  void setStartDate(DateTime newStartDate) {
    startDate = newStartDate;
  }

  void setEndDate(DateTime newEndDate) {
    endDate = newEndDate;
  }

  void incrementPrice() {
    price += 10;
    priceController.text = price.toString();
  }

  void decrementPrice() {
    if (price > 0) {
      price -= 10;
      priceController.text = price.toString();
    }
  }

  List<DateTime> generateActiveDates(DateTime start, int days) {
    return List<DateTime>.generate(
      days,
      (index) => DateTime(start.year, start.month, start.day + index),
    );
  }

  Future<void> createSlot() async {
    if (startDate == null || endDate == null) {
      emit(const BoardingSlotFailure("Please choose start and end dates."));
      return;
    }
    if (endDate!.isBefore(startDate!) || endDate == startDate) {
      emit(const BoardingSlotFailure(
          "End date cant be before start date or in the same day."));
      return;
    }

    if (price <= 0.0) {
      emit(const BoardingSlotFailure("Please enter a valid price."));
      return;
    }
    emit(BoardingSlotLoading());
    await Future.delayed(const Duration(seconds: 1));
    final result = await homeRepo.createSlot(
      price: price,
      startTime: startDate!,
      endTime: endDate!,
    );
    result.fold(
      (failure) => emit(BoardingSlotFailure(failure.errorMessage)),
      (_) => emit(BoardingSlotSuccess()),
    );
  }
}
