// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:petprovider_frontend/features/grooming/data/repo/grooming_repo_impl.dart';

part 'grooming_state.dart';

class GroomingCubit extends Cubit<GroomingState> {
  final GroomingRepoImpl groomingRepoImpl;

  GroomingCubit(
    this.groomingRepoImpl,
  ) : super(GroomingInitial()) {
    // Initialize TextEditingController for each grooming type
    for (int i = 0; i < groomingTypes.length; i++) {
      controllers.add(TextEditingController());
    }
  }

  final List<Map<String, dynamic>> groomingTypes = [
    {'type': 'Bathing', 'price': 0.0},
    {'type': 'Nail trimming', 'price': 0.0},
    {'type': 'Fur trimming', 'price': 0.0},
    {'type': 'Full package', 'price': 0.0},
  ];
  GlobalKey<FormState> formKey = GlobalKey();
  List<bool> selectedTypes = [false, false, false, false];
  List<TextEditingController> controllers = [];

  void clickGroomingType(int index) {
    selectedTypes[index] = !selectedTypes[index];
    emit(GroomingTypesUpdated(List.from(selectedTypes)));
  }

  void setGroomingTypePrice(int index, double price) {
    groomingTypes[index]['price'] = price;
    emit(GroomingTypesUpdated(List.from(selectedTypes)));
  }

  Future<void> submitGroomingTypes(
      {required String groomingType, required double price}) async {
    // print('groomingType $groomingType');
    emit(GroomingTypesLoading());
    await Future.delayed(const Duration(seconds: 1));
    var result = await groomingRepoImpl.setGroomingType(
        groomingType: groomingType, price: price);
    result.fold(
      (l) => emit(GroomingTypesFailure(l.errorMessage)),
      (r) => emit(
          const GroomingTypesSuccess('Grooming types submitted successfully')),
    );
  }

  // List<Map<String, dynamic>> getFilteredGroomingTypes(
  //     List<dynamic> existingTypes) {
  //   print('exist $existingTypes');
  //   // print(groomingTypes
  //   //     .where((type) => !existingTypes.contains(type['price'] == 0))
  //   //     .toList());
  //   return groomingTypes
  //       .where((type) => !existingTypes.contains(type['type']))
  //       .toList();
  // }

  List<Map<String, dynamic>> getFilteredGroomingTypes(
      List<dynamic> existingTypes) {
    return groomingTypes
        .where((type) => !existingTypes.any(
            (existingType) => existingType['grooming_type'] == type['type']))
        .toList();
  }

  @override
  Future<void> close() {
    for (var controller in controllers) {
      controller.dispose();
    }
    return super.close();
  }
}
