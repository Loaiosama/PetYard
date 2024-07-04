import 'package:equatable/equatable.dart';

abstract class WalkingRequestState extends Equatable {
  const WalkingRequestState();

  @override
  List<Object> get props => [];
}

class WalkingRequestInitial extends WalkingRequestState {}

class WalkingRequestLoading extends WalkingRequestState {}

class WalkingRequestSuccess extends WalkingRequestState {
  final String message;

  const WalkingRequestSuccess(this.message);
}

class WalkingRequestFailure extends WalkingRequestState {
  final String error;

  const WalkingRequestFailure(this.error);
}
