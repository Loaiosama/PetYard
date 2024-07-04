import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/walking_request.dart';

abstract class WalkingRequestState extends Equatable {
  @override
  List<Object> get props => [];
}

class WalkingRequestInitial extends WalkingRequestState {}

class WalkingRequestLoading extends WalkingRequestState {}

class WalkingRequestSuccess extends WalkingRequestState {
  final List<PendingWalkingRequest> requests;

  WalkingRequestSuccess(this.requests);
}

class WalkingRequestFailure extends WalkingRequestState {
  final String message;

  WalkingRequestFailure(this.message);
}
