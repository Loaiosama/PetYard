import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTab extends StatefulWidget {
  final DateTime? selectedDate;
  final TimeOfDay? startHour;
  final TimeOfDay? endHour;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onStartHourSelected;
  final Function(TimeOfDay) onEndHourSelected;

  const DateTab({
    Key? key,
    required this.selectedDate,
    required this.startHour,
    required this.endHour,
    required this.onDateSelected,
    required this.onStartHourSelected,
    required this.onEndHourSelected,
  }) : super(key: key);

  @override
  _DateTabState createState() => _DateTabState();
}

class _DateTabState extends State<DateTab> {
  List<DateTime> _dates = List.generate(7, (index) {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day + index);
  });

  void _updateStartHour(int hour, int minute, bool isAm) {
    widget.onStartHourSelected(
      TimeOfDay(hour: isAm ? hour % 12 : (hour % 12) + 12, minute: minute),
    );
  }

  void _updateEndHour(int hour, int minute, bool isAm) {
    widget.onEndHourSelected(
      TimeOfDay(hour: isAm ? hour % 12 : (hour % 12) + 12, minute: minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Choose Start Date",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            itemBuilder: (context, index) {
              DateTime date = _dates[index];
              bool isSelected = widget.selectedDate == date;
              return GestureDetector(
                onTap: () {
                  widget.onDateSelected(date);
                },
                child: Container(
                  width: 60,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(date),
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black),
                      ),
                      Text(
                        "${date.day}",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black),
                      ),
                      Text(
                        DateFormat('EEE').format(date),
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        Text("Choose Start and End Hours",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: widget.startHour!,
                );
                if (newTime != null) {
                  widget.onStartHourSelected(newTime);
                }
              },
              child: Column(
                children: [
                  Text(
                    "Start Hour",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.startHour?.format(context) ?? "",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: widget.endHour ?? TimeOfDay.now(),
                );
                if (newTime != null) {
                  widget.onEndHourSelected(newTime);
                }
              },
              child: Column(
                children: [
                  Text(
                    "End Hour",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.endHour?.format(context) ?? "",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
