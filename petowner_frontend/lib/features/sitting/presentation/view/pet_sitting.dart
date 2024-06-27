import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/reserve%20service/presentation/view/widgets/payment_tab.dart';
import 'package:petowner_frontend/features/sitting/data/model/sitting_request%20.dart';
import 'package:petowner_frontend/features/sitting/data/repo/sitting_repo.dart';
import 'package:petowner_frontend/features/sitting/data/repo/sitting_repo_imp.dart';

import 'package:petowner_frontend/features/sitting/presentation/view%20model/send_sitting_req_cubit.dart';
import 'package:petowner_frontend/features/sitting/presentation/view%20model/send_sitting_req_states.dart';
import 'package:petowner_frontend/features/sitting/presentation/view/widgets/date_tab.dart';
import 'package:petowner_frontend/features/sitting/presentation/view/widgets/payment_tab.dart';
import 'package:petowner_frontend/features/sitting/presentation/view/widgets/summary_tab.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/reserve%20service/presentation/view/widgets/payment_tab.dart';
import 'package:petowner_frontend/features/sitting/data/model/sitting_request%20.dart';
import 'package:petowner_frontend/features/sitting/data/repo/sitting_repo.dart';
import 'package:petowner_frontend/features/sitting/data/repo/sitting_repo_imp.dart';

import 'package:petowner_frontend/features/sitting/presentation/view%20model/send_sitting_req_cubit.dart';
import 'package:petowner_frontend/features/sitting/presentation/view%20model/send_sitting_req_states.dart';
import 'package:petowner_frontend/features/sitting/presentation/view/widgets/date_tab.dart';
import 'package:petowner_frontend/features/sitting/presentation/view/widgets/payment_tab.dart';
import 'package:petowner_frontend/features/sitting/presentation/view/widgets/summary_tab.dart';

class PetSitting extends StatefulWidget {
  const PetSitting({Key? key}) : super(key: key);

  @override
  _PetSittingState createState() => _PetSittingState();
}

class _PetSittingState extends State<PetSitting> {
  int _currentStep = 0;
  DateTime? _selectedDate;
  TimeOfDay? _startHour;
  TimeOfDay? _endHour;
  String? selectedName;
  int? selectedId;
  DateTime? startDate;
  DateTime? endDate;
  double? price;

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invalid Time Selection'),
          content: Text(
              'End time must be after start time. Please adjust the time.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _validateAndProceed() {
    if (_selectedDate != null && _startHour != null && _endHour != null) {
      if (endDateTime!.isAfter(startDateTime!)) {
        setState(() {
          if (_currentStep < steps().length - 1) {
            _currentStep += 1;
          }
        });
      } else {
        _showErrorDialog();
      }
    } else {
      _showErrorDialog();
    }
  }

  List<Step> steps() => [
        Step(
          title: const Text(''),
          label: Text(
            "Date",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: DateTab(
            selectedDate: _selectedDate,
            startHour: _startHour,
            endHour: _endHour,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            onStartHourSelected: (time) {
              setState(() {
                _startHour = time;
              });
            },
            onEndHourSelected: (time) {
              setState(() {
                _endHour = time;
              });
            },
            onSelectedName: (petName) {
              setState(() {
                selectedName = petName;
              });
            },
            onselectedId: (PetId) {
              setState(() {
                selectedId = PetId;
              });
            },
            onStartDate: (start) {
              setState(() {
                startDate = start;
              });
            },
            onEndDate: (end) {
              setState(() {
                endDate = end;
              });
            },
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text(''),
          label: Text(
            "Payment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: PaymentTabSitting(
            onPriceSelected: (p) {
              price = p;
            },
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: const Text(''),
          label: Text(
            "Summary",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Summary(
              endTime: endDate,
              startTime: startDate,
              pricee: price,
              PteName: selectedName,
              petId: selectedId),
          isActive: _currentStep >= 2,
        ),
      ];

  DateTime? get startDateTime {
    if (_selectedDate == null || _startHour == null) return null;
    return DateTime(_selectedDate!.year, _selectedDate!.month,
        _selectedDate!.day, _startHour!.hour, _startHour!.minute);
  }

  DateTime? get endDateTime {
    if (_selectedDate == null || _endHour == null) return null;
    return DateTime(_selectedDate!.year, _selectedDate!.month,
        _selectedDate!.day, _endHour!.hour, _endHour!.minute);
  }

  SittingRequest? request;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SittingReqCubit(
        sittingRepo: SittingRepoImp(apiService: ApiService(dio: Dio())),
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 18.0.sp,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Make Sitting Request",
            style: TextStyle(fontWeight: FontWeight.bold),
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
                    type: StepperType.horizontal,
                    steps: steps(),
                    currentStep: _currentStep,
                    onStepTapped: (value) {
                      setState(() {
                        _currentStep = value;
                      });
                    },
                    onStepCancel: () {
                      setState(() {
                        if (_currentStep > 0) {
                          _currentStep -= 1;
                        } else {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    onStepContinue: () {
                      if (_currentStep < 2) {
                        _currentStep += 1;
                      }
                    },
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
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _currentStep--;
                                });
                              },
                              child: Text('Back'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: kPrimaryGreen,
                                minimumSize: Size(double.infinity, 50.h),
                              ),
                            ),
                          ),
                    _currentStep == 0
                        ? Container()
                        : const SizedBox(width: 16.0),
                    Expanded(
                      child: BlocConsumer<SittingReqCubit, SittingReqState>(
                        listener: (context, state) {
                          if (state is SittingReqSuccess) {
                            context.pushNamed(
                              Routes.KSuccessReq,
                              extra: {
                                'request': request,
                                'selectedName': selectedName,
                              },
                            );
                          } else if (state is SittingReqFailure) {
                            GoRouter.of(context)
                                .push(Routes.kReservationFailure);
                          }
                        },
                        builder: (context, state) {
                          if (state is SittingReqLoading) {
                            return TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor: kPrimaryGreen,
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
                          return TextButton(
                            onPressed: () {
                              if (_currentStep < steps().length - 1) {
                                _validateAndProceed();
                              } else {
                                var cubit =
                                    BlocProvider.of<SittingReqCubit>(context);
                                request = SittingRequest(
                                  startTime: startDate,
                                  endTime: endDate,
                                  petID: selectedId,
                                  finalPrice: price,
                                  location: Location(x: 31.2089, y: 30.0131),
                                );
                                cubit.sendReq(request!);
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: kPrimaryGreen,
                              minimumSize: Size(double.infinity, 50.h),
                            ),
                            child: Text(
                              _currentStep < steps().length - 1
                                  ? 'Continue'
                                  : 'Make Request',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
