import 'package:equatable/equatable.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object?> get props => [];
}

class ApplicationInitial extends ApplicationState {}

class ApplicationLoading extends ApplicationState {}

class ApplicationSuccess extends ApplicationState {
  final String message;

  const ApplicationSuccess(this.message);
}

class ApplicationFailure extends ApplicationState {
  final String error;

  const ApplicationFailure(this.error);
}
