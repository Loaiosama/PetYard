import 'package:flutter/material.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';

class DateOfBirthTexTField extends StatefulWidget {
  const DateOfBirthTexTField({super.key});

  @override
  State<DateOfBirthTexTField> createState() => _DateOfBirthTexTFieldState();
}

class _DateOfBirthTexTFieldState extends State<DateOfBirthTexTField> {
  TextEditingController controller = TextEditingController();
  DateTime? _selectedDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        controller.text = '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectDate(context),
      child: AbsorbPointer(
        absorbing: true,
        child: TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: '26/1/2003',
            suffixIcon: IconButton(
                onPressed: () {
                  selectDate(context);
                },
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: iconColor,
                )),
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 18,
            ),
            border: customBorder,
            enabledBorder: customEnabledOutlinedBorder,
          ),
        ),
      ),
    );
  }
}
