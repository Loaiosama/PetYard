import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/applications/data/model/sitting_application.dart';

abstract class SittingAppState extends Equatable {
  const SittingAppState();

  @override
  List<Object?> get props => [];
}

class SittingAppInitial extends SittingAppState {}

class SittingAppLoading extends SittingAppState {}

class SittingAppSuccess extends SittingAppState {
  final List<SittingApplication> applications;

  SittingAppSuccess(this.applications);
}

class SittingAppFailure extends SittingAppState {
  final String message;

  SittingAppFailure(this.message);
}
