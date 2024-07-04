import 'package:equatable/equatable.dart';

abstract class ApplyWalkingRequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplyWalkingRequestInitial extends ApplyWalkingRequestState {}

class ApplyWalkingRequestLoading extends ApplyWalkingRequestState {}

class ApplyWalkingRequestSuccess extends ApplyWalkingRequestState {
  final String message;

  ApplyWalkingRequestSuccess(this.message);
}

class ApplyWalkingRequestFailure extends ApplyWalkingRequestState {
  final String error;

  ApplyWalkingRequestFailure(this.error);
}
