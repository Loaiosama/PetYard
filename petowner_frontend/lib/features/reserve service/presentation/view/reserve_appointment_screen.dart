import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/reserve%20service/data/repo/reserve_service_repo_impl.dart';
import 'package:petowner_frontend/features/reserve%20service/presentation/view%20model/cubit/boarding_slots_cubit.dart';
import 'widgets/date_time_tab.dart';
import 'widgets/payment_tab.dart';
import 'widgets/summary_tab.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({
    super.key,
    required this.serviceName,
    required this.providerId,
    required this.providerName,
  });
  final String providerName;
  final String serviceName;
  final int providerId;

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  int _currentStep = 0;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedPet;
  int? slotId;
  int? finalCost;
  int? selectedPetID;
  List<Step> steps() => [
        Step(
          title: const Text(''),
          label: Text(
            'Date & Time',
            style: Styles.styles10w400,
          ),
          content: DateTimeTab(
            onDateTimeSelected: (start, end, pet, id) {
              setState(() {
                startDate = start;
                endDate = end;
                selectedPet = pet;
                selectedPetID = id;
              });
            },
            providerId: widget.providerId,
          ),
          isActive: _currentStep >= 0,
          // state: StepState.disabled,
        ),
        Step(
          isActive: _currentStep >= 1,
          title: const Text(''),
          state: _validateFields() ? StepState.indexed : StepState.disabled,
          // state: StepState.disabled,
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
          // state: StepState.disabled,
          label: Text(
            'Summary',
            style: Styles.styles10w400,
          ),
          content: SummaryTab(
            selectedPetName: selectedPet ?? 'No Name',
            fees: finalCost ?? 0,
            startDate: startDate ?? DateTime.now(),
            endDate: endDate ?? DateTime.now(),
            providerName: widget.providerName,
          ),
        ),
      ];

  // Validate if the required fields are selected
  bool _validateFields() {
    bool isValid = true;
    if (startDate == null ||
        endDate == null ||
        selectedPet == null ||
        selectedPet!.isEmpty) {
      // Show an error message if any of the fields are not selected
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Please select start date, end date, and pet.'),
      //   ),
      // );
      isValid = false;
    } else if (endDate!.isBefore(startDate!)) {
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
          'Book ${widget.serviceName} Appointment',
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
                    child: BlocProvider(
                      create: (context) => BoardingSlotsCubit(
                          ReserveServiceRepoImpl(
                              apiService: ApiService(dio: Dio()))),
                      child:
                          BlocConsumer<BoardingSlotsCubit, BoardingSlotsState>(
                        listener: (context, state) {
                          if (state is ReserveSlotSuccess) {
                            GoRouter.of(context)
                                .push(Routes.kReservationSuccess);
                          } else if (state is ReserveSlotFailure) {
                            GoRouter.of(context)
                                .push(Routes.kReservationFailure);
                          }
                        },
                        builder: (context, state) {
                          if (state is ReserveSlotLoading) {
                            return TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: kPrimaryGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                minimumSize: Size(double.infinity, 50.h),
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: 20.sp,
                                  width: 20.sp,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                          return PetYardTextButton(
                            onPressed: () async {
                              debugPrint('startDate = $startDate');
                              debugPrint('endDate = $endDate');
                              debugPrint('selected = $selectedPet');
                              debugPrint('pet id = $selectedPetID');
                              debugPrint('slot id = $slotId');
                              if (_currentStep == steps().length - 2) {
                                var reserve = ReserveServiceRepoImpl(
                                    apiService: ApiService(dio: Dio()));
                                var res = await reserve.fetchBoardingSlots(
                                    providerId: widget.providerId);
                                res.fold(
                                  (failure) {
                                    // Print the error message contained in the failure object
                                    // print('Error: ${failure.errorMessage}');
                                  },
                                  (data) {
                                    // Handle the successful data retrieval
                                    // print(data);
                                    // print(data.data![0].slotId);
                                    setState(() {
                                      slotId = data.data![0].slotId;
                                    });
                                  },
                                );
                                debugPrint('slot id = $slotId');
                                var fees = await reserve.feesDisplay(
                                    startDate: startDate!,
                                    endDate: endDate!,
                                    slotID: slotId!);
                                fees.fold((l) => l, (cost) {
                                  setState(() {
                                    finalCost = cost;
                                  });
                                  // print('Fees: $cost');
                                  // print('Fees: $finalCost');
                                });
                                // setState(() {
                                //   finalCost = fees;
                                // });
                                // print('fees ${fees.toString()}');
                              }

                              if (_validateFields()) {
                                if (_currentStep < steps().length - 1) {
                                  setState(() {
                                    _currentStep++;
                                  });
                                } else {
                                  var cubit =
                                      BlocProvider.of<BoardingSlotsCubit>(
                                          context);
                                  cubit.reserveSlot(
                                    startDate: startDate!,
                                    endDate: endDate!,
                                    slotID: slotId!,
                                    petID: selectedPetID!,
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please select valid start date, end date, and pet.'),
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
                          );
                        },
                      ),
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
