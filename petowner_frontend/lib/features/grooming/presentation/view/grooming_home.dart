import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/loading_button.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/grooming/data/repo/grooming_repo_impl.dart';
import 'package:petowner_frontend/features/grooming/presentation/view/grooming_date_time_tab.dart';
import 'package:petowner_frontend/features/grooming/presentation/view/grooming_summary_tab.dart';
import 'package:petowner_frontend/features/grooming/presentation/view_model/grooming_service/grooming_service_cubit.dart';
import 'package:petowner_frontend/features/grooming/presentation/view_model/grooming_service/grooming_service_state.dart';
import 'package:petowner_frontend/features/provider%20profile/data/models/provider_info_model/data.dart';
import 'package:petowner_frontend/features/reserve%20service/presentation/view/widgets/payment_tab.dart';

class GroomingHomeScreen extends StatefulWidget {
  const GroomingHomeScreen({
    super.key,
    required this.serviceName,
    required this.providerId,
    required this.providerName,
    required this.services,
    required this.providerImage,
    required this.rating,
    this.count,
  });
  final String providerName;
  final String serviceName;
  final int providerId;
  final List<Service> services;
  final String providerImage;
  final num rating;
  final dynamic count;
  @override
  State<GroomingHomeScreen> createState() => _GroomingHomeScreenState();
}

class _GroomingHomeScreenState extends State<GroomingHomeScreen> {
  int _currentStep = 0;
  DateTime? date;
  String? selectedPet;
  List types = [];
  int? slotId;
  double? finalCost;
  int? selectedPetID;
  DateTime? startTime;
  DateTime? endTime;
  List<Step> steps() => [
        Step(
          title: const Text(''),
          label: Text(
            'Date & Time',
            style: Styles.styles10w400,
          ),
          content: GroomingDateTimeTab(
            providerId: widget.providerId,
            onPetSelected: (p0, p1) {
              setState(() {
                selectedPetID = p0;
                selectedPet = p1;
              });
            },
            onDateSelected: (p0) {
              setState(() {
                date = p0;
              });
            },
            onStartEndTimeSelected: (p0, p1) {
              setState(() {
                startTime = p0;
                endTime = p1;
              });
            },
            onSlotSelected: (p0) {
              // print(slotId);
              setState(() {
                slotId = p0;
              });
            },
            onTypesSelected: (p0) {
              // print(types);
              setState(() {
                types = p0 ?? [];
              });
            },
          ),
          isActive: _currentStep >= 0,
          // state: StepState.disabled,
        ),
        Step(
          isActive: _currentStep >= 1,
          title: const Text(''),
          // state: _validateFields() ? StepState.indexed : StepState.disabled,
          state: StepState.disabled,
          label: Text(
            'Payment',
            style: Styles.styles10w400,
          ),
          content: const PaymentTab(),
        ),
        Step(
          isActive: _currentStep >= 2,
          title: const Text(''),
          // state: _validateFields() ? StepState.indexed : StepState.disabled,
          state: StepState.disabled,
          label: Text(
            'Summary',
            style: Styles.styles10w400,
          ),
          content: GroomingSummaryTab(
            providerName: widget.providerName,
            date: date ?? DateTime.now(),
            fees: finalCost ?? 0.0,
            selectedPetName: selectedPet ?? '',
            service: widget.services,
            types: types,
            startTime: startTime ?? DateTime.now(),
            endTime: endTime ?? DateTime.now(),
            providerImage: widget.providerImage,
            rating: widget.rating,
            count: widget.count,
          ),
        ),
      ];

  // Validate if the required fields are selected
  bool _validateFields() {
    bool isValid = false;
    if (slotId != null && types.isNotEmpty && selectedPetID != null) {
      // print(slotId);
      // print(types.isNotEmpty);
      // print(selectedPetID);

      // print('hmm');
      isValid = true;
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
                  onStepContinue: () {
                    setState(() {
                      _currentStep += 1;
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
                      create: (context) => GroomingServiceCubit(
                          GroomingRepoImpl(apiService: ApiService(dio: Dio()))),
                      child: BlocConsumer<GroomingServiceCubit,
                          GroomingServiceState>(
                        listener: (context, state) {
                          if (state is ReserveSlotSuccess) {
                            GoRouter.of(context)
                                .push(Routes.kReservationSuccess, extra: {
                              'services': widget.services,
                              'providerName': widget.providerName,
                              'startTime': startTime,
                              'endTime': endTime,
                              'date': date,
                              'serviceName': widget.serviceName,
                              'image': widget.providerImage,
                              'rating': widget.rating,
                              'count': widget.count,
                            });
                          } else if (state is ReserveSlotFailure) {
                            GoRouter.of(context)
                                .push(Routes.kReservationFailure);
                          }
                        },
                        builder: (context, state) {
                          if (state is ReserveSlotLoading) {
                            return const LoadingButton();
                          }
                          return PetYardTextButton(
                            onPressed: () async {
                              GroomingRepoImpl groomingRepoImpl =
                                  GroomingRepoImpl(
                                      apiService: ApiService(dio: Dio()));
                              if (_currentStep == steps().length - 2) {
                                var fees = await groomingRepoImpl.feesDisplay(
                                    groomingTypes: types
                                        .map((type) => type.toString())
                                        .toList(),
                                    providerId: widget.providerId);
                                // print('fees ${fees}');
                                fees.fold((l) => null, (cost) {
                                  setState(() {
                                    finalCost = cost;
                                  });
                                });
                                // print('fees ==== $finalCost');
                              }
                              // print(date);
                              // print(startTime);
                              // print(endTime);
                              // print('abl validate $slotId');
                              if (_validateFields()) {
                                if (_currentStep < steps().length - 1) {
                                  setState(() {
                                    _currentStep++;
                                  });
                                } else {
                                  var cubit =
                                      BlocProvider.of<GroomingServiceCubit>(
                                          context);
                                  cubit.reserveGroomingSlot(
                                    slotID: slotId ?? -1,
                                    petID: selectedPetID ?? -1,
                                    groomingTypes: types,
                                  );
                                }
                                // print('hell yeah');
                                // print(_currentStep);
                                // print('Slotid = $slotId');
                                // print(selectedPet);
                                // print(selectedPetID);
                                // print(types);
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please choose slot, grooming type, and pet. ')));
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
