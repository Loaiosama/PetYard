import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/grooming/data/repo/grooming_repo_impl.dart';
import 'package:petowner_frontend/features/grooming/presentation/view_model/cubit/grooming_types_cubit.dart';
import 'package:petowner_frontend/features/grooming/presentation/view_model/grooming_service/grooming_service_cubit.dart';
import 'package:petowner_frontend/features/grooming/presentation/view_model/grooming_service/grooming_service_state.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo_impl.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/active_pets_cubit/active_pets_cubit_cubit.dart';

class GroomingDateTimeTab extends StatelessWidget {
  const GroomingDateTimeTab(
      {super.key,
      required this.onSlotSelected,
      required this.onPetSelected,
      required this.onTypesSelected,
      required this.providerId,
      required this.onDateSelected,
      required this.onStartEndTimeSelected});
  final Function(int?) onSlotSelected;
  final Function(int?, String?) onPetSelected;
  final Function(List?) onTypesSelected;
  final Function(DateTime?) onDateSelected;
  final Function(DateTime?, DateTime?) onStartEndTimeSelected;

  final int providerId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroomingServiceCubit(
          GroomingRepoImpl(apiService: ApiService(dio: Dio())))
        ..fetchGroomingSlots(providerId),
      child: GroomingDateTimeTabView(
        onSlotSelected: onSlotSelected,
        onPetSelected: onPetSelected,
        onTypesSelected: onTypesSelected,
        onDateSelected: onDateSelected,
        onStartEndTimeSelected: onStartEndTimeSelected,
        providerId: providerId,
      ),
    );
  }
}

class GroomingDateTimeTabView extends StatelessWidget {
  const GroomingDateTimeTabView(
      {super.key,
      required this.onSlotSelected,
      required this.onPetSelected,
      required this.onTypesSelected,
      required this.onDateSelected,
      required this.onStartEndTimeSelected,
      required this.providerId});
  final Function(int?) onSlotSelected;
  final Function(int?, String?) onPetSelected;
  final Function(List?) onTypesSelected;
  final Function(DateTime?) onDateSelected;
  final Function(DateTime?, DateTime?) onStartEndTimeSelected;
  final int providerId;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroomingServiceCubit, GroomingServiceState>(
      builder: (context, state) {
        var cubit = BlocProvider.of<GroomingServiceCubit>(context);
        final selectedDate = cubit.selectedDate ?? DateTime.now();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatePicker(
              DateTime.now(),
              height: 98.h,
              activeDates:
                  state is GroomingSlotsLoaded ? state.activeDates : [],
              selectionColor: kPrimaryGreen,
              onDateChange: (date) {
                cubit.selectDate(date);
                onDateSelected(cubit.selectedDate);
              },
            ),
            heightSizedBox(20),
            Text(
              'Available Slots for ${DateFormat('yyyy-MM-dd').format(selectedDate)}:',
              style: Styles.styles14w600,
            ),
            heightSizedBox(20),
            if (state is GroomingSlotsLoaded)
              SizedBox(
                height: 190.h,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 3.0,
                  ),
                  itemCount: state.groomingSlots
                      .where((slot) => slot.data!.any((datum) =>
                          datum.startTime!.year == selectedDate.year &&
                          datum.startTime!.month == selectedDate.month &&
                          datum.startTime!.day == selectedDate.day))
                      .length,
                  itemBuilder: (context, index) {
                    var filteredSlots = state.groomingSlots
                        .where((slot) => slot.data!.any((datum) =>
                            datum.startTime!.year == selectedDate.year &&
                            datum.startTime!.month == selectedDate.month &&
                            datum.startTime!.day == selectedDate.day))
                        .toList();
                    bool isSelected = cubit.isSlotSelected(index);
                    var datum = filteredSlots[index].data!.firstWhere((datum) =>
                        datum.startTime!.year == selectedDate.year &&
                        datum.startTime!.month == selectedDate.month &&
                        datum.startTime!.day == selectedDate.day);

                    return GestureDetector(
                      onTap: () {
                        cubit.selectSlot(index);
                        onStartEndTimeSelected(datum.startTime, datum.endTime);
                        // print(datum.startTime);
                        onSlotSelected(datum.slotId);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected ? kPrimaryGreen : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                        child: Center(
                          child: Text(
                            '${DateFormat('HH:mm').format(datum.startTime!)} - ${DateFormat('HH:mm').format(datum.endTime!)}',
                            style: Styles.styles14NormalBlack.copyWith(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Divider(color: Colors.grey.shade500),
            heightSizedBox(10),
            GroomingTypes(
              onTypesSelected: onTypesSelected,
              providerId: providerId,
            ),
            heightSizedBox(10),
            Text(
              'Choose pet:',
              style: Styles.styles14w600,
            ),
            heightSizedBox(10),
            PetListView(
              onTap: (id, name) {
                cubit.selectPet(id, name);
                onPetSelected(id, name);
              },
              id: cubit.selectedPet,
            ),
          ],
        );
      },
    );
  }
}

class GroomingTypes extends StatefulWidget {
  const GroomingTypes(
      {super.key, required this.onTypesSelected, required this.providerId});
  final Function(List?) onTypesSelected;
  final int providerId;
  @override
  State<GroomingTypes> createState() => _GroomingTypesState();
}

class _GroomingTypesState extends State<GroomingTypes> {
  List<String> types = [
    'Bathing',
    'Fur trimming',
    'Nail trimming',
    'Full package'
  ];
  List<int> selectedTypeIndices = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroomingTypesCubit(
          GroomingRepoImpl(apiService: ApiService(dio: Dio())))
        ..fetchGroomingTypes(widget.providerId),
      child: BlocBuilder<GroomingTypesCubit, GroomingTypesState>(
        builder: (context, state) {
          if (state is GroomingTypesLoading) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        height: 30.h,
                        width: 110.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          } else if (state is GroomingTypesLoaded) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(state.types.length, (index) {
                  bool isTypeSelected = selectedTypeIndices.contains(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isTypeSelected) {
                          selectedTypeIndices.remove(index);
                        } else {
                          selectedTypeIndices.add(index);
                        }
                      });
                      widget.onTypesSelected(selectedTypeIndices
                          .map((i) => state.types[i])
                          .toList());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isTypeSelected
                              ? kPrimaryGreen
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.types[index],
                              style: Styles.styles14NormalBlack.copyWith(
                                color: isTypeSelected
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          } else if (state is GroomingTypesError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Container();
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
    required this.id,
  });
  final void Function(int id, String name) onTap;
  final int id;
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
            return SizedBox(
              height: 100.h,
              child: Row(
                children: [
                  // heightSizedBox(10),
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.allPets.length,
                    itemBuilder: (context, index) {
                      final pet = state.allPets[index].data![0];
                      int? petId = pet.petId;
                      bool isSelected = id == pet.petId;
                      // print(petId);
                      // print(isSelected);
                      return PetListItem(
                        petId: petId ?? -1,
                        onTap: () {
                          onTap(petId!, pet.name!);
                          // print('petId $petId');
                        },
                        image: pet.image ?? '',
                        petName: pet.name ?? 'No Name',
                        index: index,
                        isSelected: isSelected,
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is ActivePetsCubitLoading) {
            // return _buildShimmerLoading();
            return const SizedBox();
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
  final int petId;
  final String image;

  const PetListItem({
    super.key,
    required this.petName,
    required this.isSelected,
    required this.onTap,
    required this.index,
    required this.image,
    required this.petId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 14.0.w, bottom: 6.0.h),
      child: InkWell(
        onTap: onTap,
        splashColor: kPrimaryGreen.withOpacity(0.2),
        child: Column(
          children: [
            Container(
              height: 56.0.h,
              width: 50.0.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  color: !isSelected
                      ? Colors.black.withOpacity(0.3)
                      : kPrimaryGreen,
                  width: 2.0.w,
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/profile_pictures/$image'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            heightSizedBox(2),
            Text(
              petName,
              style: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w600,
                color: !isSelected ? Colors.black : kPrimaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
