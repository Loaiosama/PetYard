import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:petprovider_frontend/features/grooming/data/repo/grooming_repo_impl.dart';

class GroomingTypesCubit extends Cubit<GroomingTypesState> {
  final GroomingRepoImpl groomingRepoImpl;

  GroomingTypesCubit(this.groomingRepoImpl) : super(GroomingTypesInitial());

  final List<Map<String, dynamic>> allGroomingTypes = [
    {'type': 'Bathing', 'price': 0.0},
    {'type': 'Nail trimming', 'price': 0.0},
    {'type': 'Fur trimming', 'price': 0.0},
    {'type': 'Full package', 'price': 0.0},
  ];

  final List<TextEditingController> controllers = [];

  void initialize(List<dynamic> types) {
    controllers.clear();
    for (int i = 0; i < allGroomingTypes.length; i++) {
      controllers.add(TextEditingController());
    }
    final excludedTypes = allGroomingTypes
        .where((type) => !types.any((t) => t['grooming_type'] == type['type']))
        .toList();
    emit(GroomingTypesLoaded(types: types, excludedTypes: excludedTypes));
  }

  Future<void> addGroomingType(
      {required String groomingType, required double price}) async {
    emit(GroomingTypesLoading());
    var result = await groomingRepoImpl.setGroomingType(
        groomingType: groomingType, price: price);
    result.fold(
      (failure) {
        emit(GroomingTypesFailure(failure.errorMessage));
      },
      (success) {
        final newType = {'grooming_type': groomingType, 'price': price};
        final currentState = state as GroomingTypesLoaded;
        final updatedTypes = List<dynamic>.from(currentState.types)
          ..add(newType);
        final updatedExcludedTypes =
            List<Map<String, dynamic>>.from(currentState.excludedTypes)
              ..removeWhere((type) => type['type'] == groomingType);
        emit(GroomingTypesUpdated(
            types: updatedTypes, excludedTypes: updatedExcludedTypes));
      },
    );
  }

  void removeGroomingType(int index) {
    final currentState = state as GroomingTypesLoaded;
    final updatedTypes = List<dynamic>.from(currentState.types)
      ..removeAt(index);
    final updatedExcludedTypes =
        List<Map<String, dynamic>>.from(currentState.excludedTypes)
          ..add(currentState.types[index]);
    emit(GroomingTypesUpdated(
        types: updatedTypes, excludedTypes: updatedExcludedTypes));
  }

  Future<void> editPrice({required double price, required String type}) async {
    emit(EditPriceLoading());
    await Future.delayed(const Duration(seconds: 1));
    var result =
        await groomingRepoImpl.updatePriceForService(price: price, type: type);
    result.fold(
        (failure) => emit(EditPriceFailure(errorMessage: failure.errorMessage)),
        (isSuccess) => emit(EditPriceSuccess(isSuccess: isSuccess)));
  }

  Future<void> deleteGroomingType(int id) async {
    emit(GroomingTypesLoading());
    var result = await groomingRepoImpl.deleteType(id: id);
    result.fold(
      (failure) {
        emit(DeleteFailure(errorMessage: failure.errorMessage));
      },
      (success) {
        emit(DeleteSucces(isDelete: success));
      },
    );
  }

  @override
  Future<void> close() {
    for (var controller in controllers) {
      controller.dispose();
    }
    return super.close();
  }
}

abstract class GroomingTypesState extends Equatable {
  const GroomingTypesState();

  @override
  List<Object> get props => [];
}

class GroomingTypesInitial extends GroomingTypesState {}

class EditPriceLoading extends GroomingTypesState {}

class EditPriceSuccess extends GroomingTypesState {
  final bool isSuccess;

  const EditPriceSuccess({required this.isSuccess});
}

class EditPriceFailure extends GroomingTypesState {
  final String errorMessage;

  const EditPriceFailure({required this.errorMessage});
}

class GroomingTypesLoading extends GroomingTypesState {}

class GroomingTypesLoaded extends GroomingTypesState {
  final List<dynamic> types;
  final List<Map<String, dynamic>> excludedTypes;

  const GroomingTypesLoaded({required this.types, required this.excludedTypes});

  @override
  List<Object> get props => [types, excludedTypes];
}

class GroomingTypesUpdated extends GroomingTypesState {
  final List<dynamic> types;
  final List<Map<String, dynamic>> excludedTypes;

  const GroomingTypesUpdated(
      {required this.types, required this.excludedTypes});

  @override
  List<Object> get props => [types, excludedTypes];
}

class GroomingTypesFailure extends GroomingTypesState {
  final String errorMessage;

  const GroomingTypesFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class DeleteSucces extends GroomingTypesState {
  final bool isDelete;

  const DeleteSucces({required this.isDelete});
}

final class DeleteFailure extends GroomingTypesState {
  final String errorMessage;

  const DeleteFailure({required this.errorMessage});
}
