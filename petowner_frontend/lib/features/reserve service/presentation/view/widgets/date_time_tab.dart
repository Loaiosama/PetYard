import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class DateTimeTab extends StatefulWidget {
  final Function(DateTime?, DateTime?, String?) onDateTimeSelected;

  const DateTimeTab({super.key, required this.onDateTimeSelected});

  @override
  State<DateTimeTab> createState() => _DateTimeTabState();
}

class _DateTimeTabState extends State<DateTimeTab> {
  DateTime? startDate;
  DateTime? endDate;
  List pets = ['Maxi', 'lolo', 'simba'];
  String? selectedPet;

  List<DateTime> activeDates = [];

  @override
  void initState() {
    super.initState();
    _updateActiveDates();
  }

  void _updateActiveDates() {
    // Parsing API response and populating activeDates
    Map<String, dynamic> apiResponse = {
      "status": "Done",
      "message": "One Data Is Here",
      "data": [
        {
          "slot_id": 1,
          "provider_id": 1,
          "service_id": 1,
          "start_time": "2024-04-22T21:00:00.000Z",
          "end_time": "2024-04-30T21:00:00.000Z",
          "price": 200
        }
      ],
      "data1": [
        {
          "reserve_id": 1,
          "slot_id": 1,
          "pet_id": 2,
          "owner_id": 1,
          "start_time": "2024-04-26T21:00:00.000Z",
          "end_time": "2024-04-30T21:00:00.000Z",
          "type": "Accepted"
        },
        {
          "reserve_id": 2,
          "slot_id": 2,
          "pet_id": 2,
          "owner_id": 2,
          "start_time": "2024-04-23T21:00:00.000Z",
          "end_time": "2024-04-24T21:00:00.000Z",
          "type": "Accepted"
        },
        // {
        //   "reserve_id": 2,
        //   "slot_id": 2,
        //   "pet_id": 2,
        //   "owner_id": 2,
        //   "start_time": "2024-04-29T21:00:00.000Z",
        //   "end_time": "2024-04-29T21:00:00.000Z",
        //   "type": "Accepted"
        // }
      ]
    };

    List<dynamic> freeSlots = apiResponse['data'];
    List<dynamic> reservedSlots = apiResponse['data1'];
    for (var slot in freeSlots) {
      DateTime startDate = DateTime.parse(slot['start_time']);
      DateTime endDate = DateTime.parse(slot['end_time']);
      for (var date = startDate;
          date.isBefore(endDate.add(const Duration(days: 1)));
          date = date.add(const Duration(days: 1))) {
        // Check if the date falls within any reserved slot
        bool isReserved = reservedSlots.any((reserve) {
          DateTime reserveStartDate = DateTime.parse(reserve['start_time']);
          DateTime reserveEndDate = DateTime.parse(reserve['end_time']);
          return date.isAfter(
                  reserveStartDate.subtract(const Duration(days: 1))) &&
              date.isBefore(reserveEndDate.add(const Duration(days: 1)));
        });

        // Add the date to activeDates if it's not reserved
        if (!isReserved) {
          activeDates.add(date);
        }
      }
    }
    // freeSlots.forEach((slot) {});

    // Remove duplicates from activeDates
    activeDates = activeDates.toSet().toList();

    setState(() {}); // Update the UI after updating activeDates
  }

  @override
  Widget build(BuildContext context) {
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
          height: 90.h,
          activeDates: activeDates,
          selectionColor: kPrimaryGreen,
          onDateChange: (date) {
            setState(() {
              startDate = date; // Assign selected start date
              widget.onDateTimeSelected(startDate, endDate, selectedPet);
            });
          },
        ),
        heightSizedBox(20),
        Text(
          'Choose End Date',
          style: Styles.styles14w600,
        ),
        heightSizedBox(16),
        DatePicker(
          DateTime.now(),
          height: 90.h,
          activeDates: activeDates,
          selectionColor: kPrimaryGreen,
          onDateChange: (date) {
            setState(() {
              endDate = date; // Assign selected start date
              widget.onDateTimeSelected(startDate, endDate, selectedPet);
            });
          },
        ),
        heightSizedBox(20),

        Text(
          'Choose Pet',
          style: Styles.styles14w600,
        ),
        heightSizedBox(20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pets.length,
          itemBuilder: (context, index) {
            final isSelected = selectedPet == pets[index];

            return PetListItem(
              petName: pets[index],
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  selectedPet = isSelected ? null : pets[index];
                  widget.onDateTimeSelected(startDate, endDate, selectedPet);
                });
              },
            );
          },
        ),

        heightSizedBox(14),
        // Spacer(),
      ],
    );
  }
}

class PetListItem extends StatelessWidget {
  final String petName;
  final bool isSelected;
  final VoidCallback onTap;

  const PetListItem({
    required this.petName,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.0.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Radio(
              value: petName,
              groupValue: isSelected ? petName : null,
              onChanged: (_) => onTap(),
            ),
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
                        image: const DecorationImage(
                          image: AssetImage('assets/images/profile_dog.jpg'),
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
