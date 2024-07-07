import 'package:equatable/equatable.dart';
import 'package:petprovider_frontend/features/pet%20walking%20start/data/model/pet_walking_request.dart';

abstract class UpcomingWalkingState extends Equatable {
  const UpcomingWalkingState();

  @override
  List<Object> get props => [];
}

class UpcomingWalkingInitial extends UpcomingWalkingState {}

class UpcomingWalkingLoading extends UpcomingWalkingState {}

class UpcomingWalkingSuccess extends UpcomingWalkingState {
  final List<WalkingRequest> requests;

  const UpcomingWalkingSuccess(this.requests);
}

class UpcomingWalkingFailure extends UpcomingWalkingState {
  final String message;

  const UpcomingWalkingFailure(this.message);
}
