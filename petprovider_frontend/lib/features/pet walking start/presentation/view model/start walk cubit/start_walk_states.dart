import 'package:equatable/equatable.dart';

abstract class StartWalkingRequestState extends Equatable {
  const StartWalkingRequestState();

  @override
  List<Object> get props => [];
}

class StartWalkingRequestInitial extends StartWalkingRequestState {}

class StartWalkingRequestLoading extends StartWalkingRequestState {}

class StartWalkingRequestSuccess extends StartWalkingRequestState {
  final String message;

  const StartWalkingRequestSuccess(this.message);
}

class StartWalkingRequestFailure extends StartWalkingRequestState {
  final String message;

  const StartWalkingRequestFailure(this.message);
}
