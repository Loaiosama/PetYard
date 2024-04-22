import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';

class DatePicker extends StatefulWidget {
  final String labelText;
  final void Function(String) onDateSelected;

  const DatePicker({Key? key, required this.labelText, required this.onDateSelected}) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  TextEditingController _dateController = TextEditingController();
  late String selectedDate;

  void initState() {
    super.initState();
    selectedDate = ''; // Initialize with an empty string
  }

  @override
    Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectDate();
      },
      child: AbsorbPointer(
        absorbing: true,
        child: TextField(
          controller: _dateController,
          decoration: InputDecoration(
            iconColor: kPrimaryGreen,
            focusColor: kPrimaryGreen,
            hintText: widget.labelText,
            filled: true,
            prefixIcon: const Icon(
              Icons.calendar_month,
              color: kPrimaryGreen,
            ),
            enabledBorder: customFocusedOutlinedBorder,
            focusedBorder: customFocusedOutlinedBorder,
            errorBorder: customErrorOutlinedBorder,
          ),
          readOnly: true,
        ),
      ),
    );
  }


  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.green, // Change primary color to green
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child ?? Container(), // Ensure child is not null
      ),
    );
    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
        widget.onDateSelected(_picked.toString().split(" ")[0]);
      });
    }
  }
}

