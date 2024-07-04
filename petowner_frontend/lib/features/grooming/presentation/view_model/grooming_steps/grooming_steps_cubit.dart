import 'package:flutter_bloc/flutter_bloc.dart';

import 'grooming_steps_state.dart';

class GroomingStepsCubit extends Cubit<GroomingStepsState> {
  GroomingStepsCubit() : super(GroomingStepsInitial());

  int _currentStep = 0; // Track the current step index internally

  int get currentStep => _currentStep;

  void nextStep() {
    if (_currentStep < maxSteps) {
      _currentStep++;
      emit(GroomingStepsUpdated(currentStep: currentStep));
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      emit(GroomingStepsUpdated(currentStep: currentStep));
    }
  }

  // Example method to reset the stepper state
  void resetStepper() {
    _currentStep = 0;
    emit(GroomingStepsInitial());
  }

  // Define more methods as needed for your application

  int get maxSteps => 3; // Example: Total number of steps in the stepper
}
