import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';

class DatePicker extends StatefulWidget {
  final String labelText;
  final void Function(DateTime) onDateSelected;
  final String? Function(String?)? validator;

  const DatePicker({
    super.key,
    required this.labelText,
    required this.onDateSelected,
    this.validator,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController _dateController = TextEditingController();
  late String selectedDate;

  @override
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
        child: SizedBox(
          child: TextFormField(
            controller: _dateController,
            validator: widget.validator,
            decoration: InputDecoration(
              iconColor: kPrimaryGreen,
              focusColor: kPrimaryGreen,
              hintText: widget.labelText,
              prefixIcon: const Icon(
                Icons.calendar_today,
                color: kPrimaryGreen,
              ),
              enabledBorder: customFocusedOutlinedBorder,
              focusedBorder: customFocusedOutlinedBorder,
              errorBorder: customErrorOutlinedBorder,
            ),
            readOnly: true,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      // lastDate: DateTime(2040),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
            primary: kPrimaryGreen, // Change primary color to green
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child ?? Container(), // Ensure child is not null
      ),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
        widget.onDateSelected(picked);
      });
    }
  }
}
