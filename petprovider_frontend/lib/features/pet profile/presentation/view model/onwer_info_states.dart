import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/pet%20profile/data/model/owner.dart';

abstract class OwnerInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OwnerInfoInitial extends OwnerInfoState {}

class OwnerInfoLoading extends OwnerInfoState {}

class OwnerInfoSuccess extends OwnerInfoState {
  final Owner owner;

  OwnerInfoSuccess(this.owner);
}

class OwnerInfoFailure extends OwnerInfoState {
  final String error;

  OwnerInfoFailure(this.error);
}
