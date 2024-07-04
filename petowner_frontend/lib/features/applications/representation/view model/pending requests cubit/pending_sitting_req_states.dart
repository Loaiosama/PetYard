import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/applications/data/model/pending_sitting_req.dart';

abstract class PendingSittingRequestsState extends Equatable {
  @override
  List<Object> get props => [];
}

class PendingSittingRequestsInitial extends PendingSittingRequestsState {}

class PendingSittingRequestsLoading extends PendingSittingRequestsState {}

class PendingSittingRequestsSuccess extends PendingSittingRequestsState {
  final List<PendingSittingReq> requests;

  PendingSittingRequestsSuccess(this.requests);
}

class PendingSittingRequestsFailure extends PendingSittingRequestsState {
  final String message;

  PendingSittingRequestsFailure(this.message);
}
