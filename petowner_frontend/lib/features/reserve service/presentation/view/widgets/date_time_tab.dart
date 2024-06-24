// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo_impl.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/active_pets_cubit/active_pets_cubit_cubit.dart';
import 'package:petowner_frontend/features/reserve%20service/data/repo/reserve_service_repo_impl.dart';
import 'package:petowner_frontend/features/reserve%20service/presentation/view%20model/cubit/boarding_slots_cubit.dart';
import 'package:shimmer/shimmer.dart';

class DateTimeTab extends StatefulWidget {
  final Function(DateTime?, DateTime?, String?, int?) onDateTimeSelected;
  final int providerId;
  const DateTimeTab(
      {super.key, required this.onDateTimeSelected, required this.providerId});

  @override
  State<DateTimeTab> createState() => _DateTimeTabState();
}

class _DateTimeTabState extends State<DateTimeTab> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedPet;
  int? selectedPetID;
  // List<DateTime> activeDates = [];

  @override
  void initState() {
    super.initState();
    // _updateActiveDates();
    selectedPet = '';
    selectedPetID = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StartEndCalendarWidget(
          onDateTimeSelected: widget.onDateTimeSelected,
          providerId: widget.providerId,
          onStartDateChange: (startdate) {
            setState(() {
              startDate = startdate; // Assign selected start date
              widget.onDateTimeSelected(
                  startDate, endDate, selectedPet, selectedPetID);
            });
          },
          onEndDateChange: (enddate) {
            setState(() {
              endDate = enddate; // Assign selected start date
              widget.onDateTimeSelected(
                  startDate, endDate, selectedPet, selectedPetID);
            });
          },
        ),
        heightSizedBox(20),

        Text(
          'Choose Pet',
          style: Styles.styles14w600,
        ),
        heightSizedBox(20),
        PetListView(
          onTap: (name, id) {
            setState(() {
              selectedPet = name;
              selectedPetID = id;
              widget.onDateTimeSelected(
                  startDate, endDate, selectedPet, selectedPetID);
            });
          },
          selectedPet: selectedPet!,
          selectedPetID: selectedPetID!,
        ),
        heightSizedBox(14),
        // Spacer(),
      ],
    );
  }
}

class StartEndCalendarWidget extends StatelessWidget {
  const StartEndCalendarWidget(
      {super.key,
      required this.onDateTimeSelected,
      required this.providerId,
      required this.onStartDateChange,
      required this.onEndDateChange});
  final Function(DateTime?, DateTime?, String?, int?) onDateTimeSelected;
  final int providerId;
  final void Function(DateTime) onStartDateChange;
  final void Function(DateTime) onEndDateChange;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardingSlotsCubit(
          ReserveServiceRepoImpl(apiService: ApiService(dio: Dio())))
        ..getFreeSlots(providerId: providerId),
      child: BlocBuilder<BoardingSlotsCubit, BoardingSlotsState>(
        builder: (context, state) {
          if (state is BoardingSlotsUpdated) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Start Date',
                  style: Styles.styles14w600,
                ),
                heightSizedBox(16),
                DatePicker(
                  DateTime.now(),
                  height: 98.h,
                  activeDates: state.activeDates,
                  selectionColor: kPrimaryGreen,
                  onDateChange: onStartDateChange,
                ),
                heightSizedBox(20),
                Text(
                  'Choose End Date',
                  style: Styles.styles14w600,
                ),
                heightSizedBox(16),
                DatePicker(
                  DateTime.now(),
                  height: 98.h,
                  activeDates: state.activeDates,
                  selectionColor: kPrimaryGreen,
                  onDateChange: onEndDateChange,
                ),
              ],
            );
          } else if (state is BoardingSlotsLoading ||
              state is BoardingSlotsSuccess ||
              state is BoardingSlotsFailure) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Start Date',
                  style: Styles.styles14w600,
                ),
                heightSizedBox(16),
                DatePicker(
                  DateTime.now(),
                  height: 98.h,
                  activeDates: const [],
                  selectionColor: kPrimaryGreen,
                  onDateChange: onEndDateChange,
                ),
                heightSizedBox(20),
                Text(
                  'Choose End Date',
                  style: Styles.styles14w600,
                ),
                DatePicker(
                  DateTime.now(),
                  height: 98.h,
                  activeDates: const [],
                  selectionColor: kPrimaryGreen,
                  onDateChange: onEndDateChange,
                ),
              ],
            );
          } else {
            return const Center(child: Text('oops'));
          }
        },
      ),
    );
  }
}

class PetListView extends StatelessWidget {
  const PetListView({
    super.key,
    required this.onTap,
    required this.selectedPet,
    required this.selectedPetID,
  });
  final void Function(String name, int id) onTap;
  final String selectedPet;
  final int selectedPetID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivePetsCubitCubit>(
      create: (context) => ActivePetsCubitCubit(
        ProfileRepoImpl(
          apiService: ApiService(
            dio: Dio(),
          ),
        ),
      )..getAllPets(),
      child: BlocBuilder<ActivePetsCubitCubit, ActivePetsCubitState>(
        builder: (context, state) {
          if (state is ActivePetsCubitSuccess) {
            return Column(
              children: [
                // =================================================
                // Add Temporary Pet Here.
                // Container(
                //   decoration: BoxDecoration(
                //     shape: BoxShape.rectangle,
                //     borderRadius: BorderRadius.circular(10.0),
                //   ),
                //   child: Row(
                //     children: [
                //       Container(
                //         height: 60.h,
                //         width: 60.h,
                //         decoration: BoxDecoration(
                //           border:
                //               Border.all(color: Colors.black.withOpacity(0.3)),
                //           shape: BoxShape.circle,
                //         ),
                //         child: Center(
                //           child: IconButton(
                //               onPressed: () {},
                //               icon: const Icon(
                //                 Icons.add,
                //                 color: kPrimaryGreen,
                //               )),
                //         ),
                //       ),
                //       widthSizedBox(16),
                //       Text(
                //         'Add temporary pet',
                //         style: Styles.styles14w600,
                //       )
                //     ],
                //   ),
                // ),
                // =================================================
                heightSizedBox(10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.allPets.length,
                  itemBuilder: (context, index) {
                    final pet = state.allPets[index].data![0];
                    bool isSelected = selectedPetID == pet.petId;
                    int? petId = pet.petId;
                    return PetListItem(
                      onTap: () {
                        onTap(pet.name!, petId!);
                      },
                      image: pet.image ?? '',
                      petName: pet.name ?? 'No Name',
                      index: index,
                      isSelected: isSelected,
                    );
                  },
                ),
              ],
            );
          } else if (state is ActivePetsCubitLoading) {
            return _buildShimmerLoading();
          } else if (state is ActivePetsCubitFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else {
            return const Text('oops');
          }
        },
      ),
    );
  }
}

class PetListItem extends StatelessWidget {
  final String petName;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  final String image;
  const PetListItem({
    super.key,
    required this.petName,
    required this.isSelected,
    required this.onTap,
    required this.index,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.0.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Radio(
            //   value: petName,
            //   groupValue: isSelected ? petName : null,
            //   onChanged: (_) {},
            // ),
            Expanded(
              child: Container(
                decoration: isSelected
                    ? BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: kPrimaryGreen,
                        borderRadius: BorderRadius.circular(10.0),
                      )
                    : null,
                child: Row(
                  children: [
                    Container(
                      height: 60.0.h,
                      width: 60.0.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/$image'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    widthSizedBox(16),
                    Padding(
                      padding: EdgeInsets.only(right: 26.0.w),
                      child: Text(
                        petName,
                        style: !isSelected
                            ? Styles.styles14w600
                            : Styles.styles14w600.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildShimmerLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            height: 60.0.h,
            width: 60.0.w,
            margin: EdgeInsets.only(bottom: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0.r),
              color: Colors.white,
            ),
          ),
          title: Container(
            width: 100,
            height: 20,
            color: Colors.white,
          ),
        );
      },
    ),
  );
}
