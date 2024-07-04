import 'package:equatable/equatable.dart';

abstract class SittingReqState extends Equatable {
  const SittingReqState();

  @override
  List<Object> get props => [];
}

class SittingReqInitial extends SittingReqState {}

class SittingReqLoading extends SittingReqState {}

class SittingReqSuccess extends SittingReqState {
  final String message;

  const SittingReqSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SittingReqFailure extends SittingReqState {
  final String error;

  const SittingReqFailure(this.error);

  @override
  List<Object> get props => [error];
}
