import 'package:equatable/equatable.dart';

abstract class ApplyRequestState extends Equatable {
  const ApplyRequestState();

  @override
  List<Object> get props => [];
}

class ApplyRequestInitial extends ApplyRequestState {}

class ApplyRequestLoading extends ApplyRequestState {}

class ApplyRequestSuccess extends ApplyRequestState {
  final String message;

  const ApplyRequestSuccess(this.message);
}

class ApplyRequestFailure extends ApplyRequestState {
  final String error;

  const ApplyRequestFailure(this.error);
}
