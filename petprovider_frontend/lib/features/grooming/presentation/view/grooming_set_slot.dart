import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/loading_button.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/grooming/data/repo/grooming_repo_impl.dart';
import 'package:petprovider_frontend/features/grooming/presentation/view_model/cubit/grooming_service_cubit.dart';

class GroomingSetSlotsTab extends StatelessWidget {
  const GroomingSetSlotsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GroomingServiceCubit(GroomingRepoImpl(api: ApiService(dio: Dio()))),
      child: BlocConsumer<GroomingServiceCubit, GroomingServiceState>(
        listener: (context, state) {
          if (state is GroomingServiceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          } else if (state is GroomingServiceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Slot created Successfully'),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<GroomingServiceCubit>();
          return SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10.0.h, right: 16.0.w, bottom: 10.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Date',
                    style: Styles.styles16w600,
                  ),
                  heightSizedBox(16),
                  DatePicker(
                    DateTime.now(),
                    height: 98.h,
                    onDateChange: (selectedDate) {
                      cubit.setSelectedDate(selectedDate);
                    },
                    activeDates: List<DateTime>.generate(36500,
                        (index) => DateTime.now().add(Duration(days: index))),
                    selectionColor: kPrimaryGreen,
                  ),
                  heightSizedBox(20),
                  Text(
                    'Choose Working Hours',
                    style: Styles.styles16w600,
                  ),
                  heightSizedBox(16),
                  Row(
                    children: [
                      TimePickerSpinner(
                        is24HourMode: false,
                        normalTextStyle:
                            TextStyle(fontSize: 14.sp, color: Colors.grey),
                        highlightedTextStyle:
                            TextStyle(fontSize: 16.sp, color: kPrimaryGreen),
                        spacing: 8.w,
                        itemHeight: 44.h,
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          cubit.setStartTime(time);
                        },
                      ),
                      TimePickerSpinner(
                        is24HourMode: false,
                        normalTextStyle:
                            TextStyle(fontSize: 14.sp, color: Colors.grey),
                        highlightedTextStyle:
                            TextStyle(fontSize: 16.sp, color: kPrimaryGreen),
                        spacing: 8.w,
                        itemHeight: 44.h,
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          cubit.setEndTime(time);
                        },
                      ),
                    ],
                  ),
                  heightSizedBox(20),
                  Text(
                    'Slot Length (minutes)',
                    style: Styles.styles16w600,
                  ),
                  heightSizedBox(16),
                  Row(
                    children: [
                      widthSizedBox(4),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          cubit.decrementSlotLength();
                        },
                      ),
                      Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 130.w,
                                child: TextFormField(
                                  readOnly: true,
                                  onChanged: (value) {
                                    cubit.setSlotLength(double.parse(value));
                                  },
                                  controller: cubit.slotLengthController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: cubit.slotLengthController.text,
                                  ),
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cubit.incrementSlotLength();
                        },
                      ),
                    ],
                  ),
                  heightSizedBox(40),
                  state is GroomingServiceLoading
                      ? const LoadingButton(
                          height: 60,
                        )
                      : PetYardTextButton(
                          onPressed: () {
                            cubit.createSlot(
                              length: cubit.slotLength.toInt(),
                            );
                          },
                          text: 'Submit!',
                          style: Styles.styles16BoldWhite,
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
