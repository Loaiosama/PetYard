import 'package:flutter/material.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/gender_button.dart';

class Gender extends StatefulWidget {
  final void Function(String) onGenderSelected;
  const Gender({super.key, required this.onGenderSelected});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
   String selectedWeight = '';
   String selectedGender = '';
  @override
  Widget build(BuildContext context) {
    return  Row(
              children: [
                Expanded(
                  child: GenderButton(
                    text: 'Male',
                    isSelected: selectedGender == 'Male',
                    onSelect: (isSelected) {
                      setState(() {
                        selectedGender = isSelected ? 'Male' : '';
                        widget.onGenderSelected(selectedGender);
                      });
                    },
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
                Expanded(
                  child: GenderButton(
                    text: 'Female',
                    isSelected: selectedGender == 'Female',
                    onSelect: (isSelected) {
                      setState(() {
                        selectedGender = isSelected ? 'Female' : '';
                        widget.onGenderSelected(selectedGender);
                      });
                    },
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
              ],
            );
  }
}