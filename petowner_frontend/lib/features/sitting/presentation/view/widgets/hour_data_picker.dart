import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';

class DateHourPicker extends StatefulWidget {
  final String labelText;
  final void Function(String) onDateSelected;

  const DateHourPicker(
      {super.key, required this.labelText, required this.onDateSelected});

  @override
  State<DateHourPicker> createState() => _DateHourPickerState();
}

class _DateHourPickerState extends State<DateHourPicker> {
  final TextEditingController _dateController = TextEditingController();
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectDateTime();
      },
      child: AbsorbPointer(
        absorbing: true,
        child: SizedBox(
          height: 56.h,
          child: TextField(
            controller: _dateController,
            decoration: InputDecoration(
              iconColor: kBlue,
              focusColor: kPrimaryGreen,
              hintText: widget.labelText,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Image.asset(
                  'assets/images/calendar_G5.png',
                  width: 40,
                  height: 40,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryGreen,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryGreen, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryGreen, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
            readOnly: true,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
            primary: KGreen,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child ?? Container(), // Ensure child is not null
      ),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.light(
              primary: KGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child ?? Container(), // Ensure child is not null
        ),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text = "${selectedDateTime.toLocal()}".split('.')[0];
          widget.onDateSelected(_dateController.text);
        });
      }
    }
  }
}
