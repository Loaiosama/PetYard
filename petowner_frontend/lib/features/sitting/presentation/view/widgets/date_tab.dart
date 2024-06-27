import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo_impl.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/active_pets_cubit/active_pets_cubit_cubit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DateTab extends StatefulWidget {
  final DateTime? selectedDate;
  final TimeOfDay? startHour;
  final TimeOfDay? endHour;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onStartHourSelected;
  final Function(TimeOfDay) onEndHourSelected;
  final Function(String) onSelectedName;
  final Function(int) onselectedId;
  final Function(DateTime) onStartDate;
  final Function(DateTime) onEndDate;

  // ignore: use_super_parameters
  const DateTab({
    Key? key,
    required this.selectedDate,
    required this.startHour,
    required this.endHour,
    required this.onDateSelected,
    required this.onStartHourSelected,
    required this.onEndHourSelected,
    required this.onSelectedName,
    required this.onselectedId,
    required this.onStartDate,
    required this.onEndDate,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DateTabState createState() => _DateTabState();
}

class _DateTabState extends State<DateTab> {
  final List<DateTime> _dates = List.generate(7, (index) {
    DateTime currentDate = DateTime.now();
    return DateTime(currentDate.year, currentDate.month, currentDate.day)
        .add(Duration(days: index));
  });

  DateTime? day;
  DateTime? endDate;
  String? selectedPet;
  int? selectedPetID;

  @override
  void initState() {
    super.initState();
    selectedPet = '';
    selectedPetID = 0;
  }

  // ignore: unused_element
  void _updateStartHour(int hour, int min, bool isAm) {
    widget.onStartHourSelected(
        TimeOfDay(hour: isAm ? hour % 12 : (hour % 12) + 12, minute: min));
  }

  // ignore: unused_element
  void _updateEndHour(int hour, int min, bool isAm) {
    widget.onEndHourSelected(
        TimeOfDay(hour: isAm ? hour % 12 : (hour % 12) + 12, minute: min));
  }

  @override
  Widget build(BuildContext context) {
    DateTime? d;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose The Day",
            style: Styles.styles20BoldBlack,
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                DateTime date = _dates[index];
                bool isSelected = widget.selectedDate == date;
                return GestureDetector(
                  onTap: () {
                    day = date;
                    widget.onDateSelected(date);
                  },
                  child: Container(
                    width: 55.w,
                    height: 98.h,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected ? kPrimaryGreen : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('MMM').format(date),
                          style: Styles.styles12NormalHalfBlack.copyWith(
                              color: isSelected ? Colors.white : Colors.black),
                        ),
                        Text(
                          "${date.day}",
                          style: Styles.styles18BoldBlack.copyWith(
                              color: isSelected ? Colors.white : Colors.black),
                        ),
                        Text(
                          DateFormat('EEE').format(date),
                          style: Styles.styles12NormalHalfBlack.copyWith(
                              color: isSelected ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            "Set The Time Frame",
            style: Styles.styles18BoldBlack,
          ),
          SizedBox(
            height: 20.h,
          ),
          GestureDetector(
            onTap: () async {
              TimeOfDay? newTime = await showTimePicker(
                context: context,
                initialTime: widget.startHour ?? TimeOfDay.now(),
              );
              if (newTime != null) {
                widget.onStartHourSelected(newTime);

                DateTime combinedDateTime =
                    combineDateTimeAndTimeOfDay(day ?? DateTime.now(), newTime);
                widget.onStartDate(combinedDateTime);
              }
            },
            child: Container(
              width: 350.w,
              height: 60.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 3),
                      color: Colors.grey,
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Start Hour :",
                    style: Styles.styles16w600,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.startHour?.format(context) ?? "",
                    style: Styles.styles20BoldBlack,
                  ),
                  SvgPicture.asset(
                    'assets/images/clock-B.svg',
                    width: 30.w,
                    height: 30.h,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          GestureDetector(
            onTap: () async {
              TimeOfDay? newTime = await showTimePicker(
                context: context,
                initialTime: widget.endHour ?? TimeOfDay.now(),
              );
              if (newTime != null) {
                widget.onEndHourSelected(newTime);
                DateTime combinedDateTime =
                    combineDateTimeAndTimeOfDay(day ?? DateTime.now(), newTime);
                widget.onEndDate(combinedDateTime);
              }
            },
            child: Container(
              width: 350.w,
              height: 60.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 3),
                      color: Colors.grey,
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "End Hour :",
                    style: Styles.styles16w600,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.endHour?.format(context) ?? "",
                    style: Styles.styles20BoldBlack,
                  ),
                  SvgPicture.asset(
                    'assets/images/clock-B.svg',
                    width: 30.w,
                    height: 30.h,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            'Choose Pet',
            style: Styles.styles14w600,
          ),
          SizedBox(
            height: 5.h,
          ),
          PetListView(
            onTap: (name, id) {
              setState(() {
                selectedPet = name;
                selectedPetID = id;
                widget.onSelectedName(selectedPet ?? "No Name");
                widget.onselectedId(selectedPetID ?? -1);
              });
            },
            selectedPet: selectedPet!,
            selectedPetID: selectedPetID!,
          ),
        ],
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
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
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
                ),
              ],
            );
          } else if (state is ActivePetsCubitLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Container(
                          height: 20,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text("Couldn't get your pets");
          }
        },
      ),
    );
  }
}

class PetListItem extends StatelessWidget {
  const PetListItem({
    Key? key,
    required this.onTap,
    required this.image,
    required this.petName,
    required this.index,
    required this.isSelected,
  }) : super(key: key);

  final Function() onTap;
  final String image;
  final String petName;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? kPrimaryGreen : Colors.transparent,
                  )),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              petName,
              style: Styles.styles16w600,
            )
          ],
        ),
      ),
    );
  }
}

DateTime combineDateTimeAndTimeOfDay(DateTime dateTime, TimeOfDay timeOfDay) {
  return DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
}
