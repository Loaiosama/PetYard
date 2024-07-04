import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/SittingRequest.dart';

abstract class SittingReqState extends Equatable {
  const SittingReqState();

  @override
  List<Object> get props => [];
}

class SittingReqInitial extends SittingReqState {}

class SittingReqLoading extends SittingReqState {}

class SittingReqFailure extends SittingReqState {
  final String errorMessage;

  const SittingReqFailure(this.errorMessage);
}

class SittingReqSuccess extends SittingReqState {
  final List<SittingRequests> requests;

  const SittingReqSuccess(this.requests);
}
