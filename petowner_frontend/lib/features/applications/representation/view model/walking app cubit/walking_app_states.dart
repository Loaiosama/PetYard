import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/applications/data/model/walking_application.dart';

abstract class WalkingApplicationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WalkingApplicationsInitial extends WalkingApplicationsState {}

class WalkingApplicationsLoading extends WalkingApplicationsState {}

class WalkingApplicationsSuccess extends WalkingApplicationsState {
  final List<WalkingApplication> walkingApplications;

  WalkingApplicationsSuccess(this.walkingApplications);

  @override
  List<Object?> get props => [walkingApplications];
}

class WalkingApplicationsFailure extends WalkingApplicationsState {
  final String message;

  WalkingApplicationsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
