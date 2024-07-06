import 'package:equatable/equatable.dart';

abstract class TrackWalkingState extends Equatable {
  const TrackWalkingState();

  @override
  List<Object> get props => [];
}

class TrackWalkingInitial extends TrackWalkingState {}

class TrackWalkingLoading extends TrackWalkingState {}

class TrackWalkingSuccess extends TrackWalkingState {
  final String message;

  const TrackWalkingSuccess(this.message);
}

class TrackWalkingFailure extends TrackWalkingState {
  final String message;

  const TrackWalkingFailure(this.message);
}
