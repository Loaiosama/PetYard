import 'package:equatable/equatable.dart';

abstract class GroomingStepsState extends Equatable {
  const GroomingStepsState();

  @override
  List<Object?> get props => [];
}

class GroomingStepsInitial extends GroomingStepsState {}

// Add more state classes as needed for your application
class GroomingStepsUpdated extends GroomingStepsState {
  final int currentStep;

  const GroomingStepsUpdated({required this.currentStep});
}
