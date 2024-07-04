import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/applications/data/model/pedning_walking_req.dart';

abstract class WalkingRequestsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WalkingRequestsInitial extends WalkingRequestsState {}

class WalkingRequestsLoading extends WalkingRequestsState {}

class WalkingRequestsSuccess extends WalkingRequestsState {
  final List<PendingWalkingRequest> walkingRequests;

  WalkingRequestsSuccess(this.walkingRequests);
}

class WalkingRequestsFailure extends WalkingRequestsState {
  final String message;

  WalkingRequestsFailure(this.message);
}
