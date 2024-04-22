import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'widgets/date_time_tab.dart';
import 'widgets/payment_tab.dart';
import 'widgets/summary_tab.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  int _currentStep = 0;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedPet;

  List<Step> steps() => [
        Step(
          title: const Text(''),
          label: Text(
            'Date & Time',
            style: Styles.styles10w400,
          ),
          content: DateTimeTab(
            onDateTimeSelected: (start, end, pet) {
              setState(() {
                startDate = start;
                endDate = end;
                selectedPet = pet;
              });
            },
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          isActive: _currentStep >= 1,
          title: const Text(''),
          state: _validateFields() ? StepState.indexed : StepState.disabled,
          label: Text(
            'Payment',
            style: Styles.styles10w400,
          ),
          content: const PaymentTab(),
        ),
        Step(
          isActive: _currentStep >= 2,
          title: const Text(''),
          state: _validateFields() ? StepState.indexed : StepState.disabled,
          label: Text(
            'Summary',
            style: Styles.styles10w400,
          ),
          content: const SummaryTab(),
        ),
      ];

  // Validate if the required fields are selected
  bool _validateFields() {
    bool isValid = true;
    if (startDate == null || endDate == null || selectedPet == null) {
      // Show an error message if any of the fields are not selected
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Please select start date, end date, and pet.'),
      //   ),
      // );
      isValid = false;
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18.0.sp,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Book Appointment',
          style: Styles.styles18SemiBoldBlack,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: kPrimaryGreen,
                  ),
                ),
                child: Stepper(
                  controlsBuilder: (context, details) {
                    return const SizedBox();
                  },
                  elevation: 0.0,
                  type: StepperType.horizontal,
                  currentStep: _currentStep,
                  // onStepContinue: () {
                  //   setState(() {
                  //     if (_currentStep < steps().length - 1) {
                  //       _currentStep += 1;
                  //     } else {
                  //       // Finish button pressed
                  //       // You can perform any final actions here
                  //     }

                  //     // if (validateStep(_currentStep)) {
                  //     //   // Continue to the next step
                  //     //   setState(() {
                  //     //     _currentStep += 1;
                  //     //   });
                  //     // }
                  //   });
                  // },
                  onStepCancel: () {
                    setState(() {
                      if (_currentStep > 0) {
                        _currentStep -= 1;
                      } else {
                        // Cancel button pressed on the first step
                      }
                    });
                  },
                  onStepTapped: (int index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  steps: steps(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _currentStep == 0
                      ? Container()
                      : Expanded(
                          child: PetYardTextButton(
                            onPressed: () {
                              setState(() {
                                _currentStep--;
                              });
                            },
                            text: 'Back',
                            height: 50.h,
                            radius: 12.0.r,
                            style: Styles.styles14w600
                                .copyWith(color: Colors.white, fontSize: 12.sp),
                          ),
                        ),
                  _currentStep == 0 ? Container() : const SizedBox(width: 16.0),
                  Expanded(
                    child: PetYardTextButton(
                      onPressed: () {
                        if (_validateFields()) {
                          _currentStep < steps().length - 1
                              ? setState(() {
                                  _currentStep++;
                                })
                              : null;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please select start date, end date, and pet.'),
                            ),
                          );
                        }
                      },
                      text: _currentStep < steps().length - 1
                          ? 'Continue'
                          : 'Book Appointment',
                      height: 50.h,
                      radius: 12.0.r,
                      style: Styles.styles14w600
                          .copyWith(color: Colors.white, fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
