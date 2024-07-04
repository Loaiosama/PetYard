import 'package:equatable/equatable.dart';

abstract class WalkingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WalkingInitial extends WalkingState {}

class WalkingLoading extends WalkingState {}

class WalkingSuccess extends WalkingState {
  final String message;

  WalkingSuccess(this.message);
}

class WalkingFailure extends WalkingState {
  final String message;

  WalkingFailure(this.message);
}
