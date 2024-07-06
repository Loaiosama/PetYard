import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/pet%20walking%20track/model/data/walking_track_request.dart';

abstract class UpcomingWalkingState extends Equatable {
  const UpcomingWalkingState();

  @override
  List<Object> get props => [];
}

class UpcomingWalkingInitial extends UpcomingWalkingState {}

class UpcomingWalkingLoading extends UpcomingWalkingState {}

class UpcomingWalkingSuccess extends UpcomingWalkingState {
  final List<WalkingTrackRequest> requests;

  const UpcomingWalkingSuccess(this.requests);
}

class UpcomingWalkingFailure extends UpcomingWalkingState {
  final String message;

  const UpcomingWalkingFailure(this.message);
}
