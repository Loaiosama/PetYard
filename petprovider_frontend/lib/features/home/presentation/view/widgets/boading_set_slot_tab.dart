import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/loading_button.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo_impl.dart';
import 'package:petprovider_frontend/features/home/presentation/view%20model/boarding_cubit/boarding_cubit_cubit.dart';

class BoardingSetSlotTab extends StatelessWidget {
  const BoardingSetSlotTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BoardingCubitCubit(HomeRepoImppl(api: ApiService(dio: Dio()))),
      child: BlocConsumer<BoardingCubitCubit, BoardingCubitState>(
        listener: (context, state) {
          if (state is BoardingSlotFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          } else if (state is BoardingSlotSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Slot created Successfully'),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<BoardingCubitCubit>();
          return Padding(
            padding: EdgeInsets.only(top: 30.0.h, right: 20.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Start Date',
                  style: Styles.styles16w600,
                ),
                heightSizedBox(16),
                DatePicker(
                  DateTime.now(),
                  height: 98.h,
                  onDateChange: (selectedDate) {
                    cubit.setStartDate(selectedDate);
                  },
                  activeDates: cubit.generateActiveDates(DateTime.now(), 36500),
                  selectionColor: kPrimaryGreen,
                ),
                heightSizedBox(20),
                Text(
                  'Choose End Date',
                  style: Styles.styles16w600,
                ),
                heightSizedBox(16),
                DatePicker(
                  DateTime.now(),
                  height: 98.h,
                  onDateChange: (selectedDate) {
                    cubit.setEndDate(selectedDate);
                  },
                  activeDates: cubit.generateActiveDates(DateTime.now(), 36500),
                  selectionColor: kPrimaryGreen,
                ),
                Text(
                  'Put your price',
                  style: Styles.styles16w600,
                ),
                heightSizedBox(16),
                Row(
                  children: [
                    widthSizedBox(4),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      // onPressed: _decrement,
                      onPressed: () {
                        cubit.decrementPrice();
                      },
                    ),
                    Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 114.w,
                              child: TextFormField(
                                onChanged: (value) {
                                  cubit.setPrice(double.parse(value));
                                },
                                controller: cubit.priceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Price/dayEGP',
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
                        cubit.incrementPrice();
                      },
                      // onPressed: _increment,
                    ),
                  ],
                ),
                heightSizedBox(40),
                state is BoardingSlotLoading
                    ? const LoadingButton(
                        height: 60,
                      )
                    : PetYardTextButton(
                        onPressed: () {
                          cubit.createSlot();
                        },
                        text: 'Submit!',
                        style: Styles.styles16BoldWhite,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
