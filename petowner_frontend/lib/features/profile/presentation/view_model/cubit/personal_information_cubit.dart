import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'personal_information_state.dart';

class PersonalInformationCubit extends Cubit<PersonalInformationState> {
  PersonalInformationCubit() : super(PersonalInformationInitial()) {
    fNameController = TextEditingController(text: fName);
    lNameController = TextEditingController(text: lName);
    emailController = TextEditingController(text: mail);
    dateController = TextEditingController(text: selectedDate);
  }

  bool isEdit = false;
  String fName = 'Mohamed';
  String lName = ' Hamdy';
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  String mail = 'mohamedhamdy@gmail.com';
  TextEditingController emailController = TextEditingController();
  String selectedGender = '';
  TextEditingController genderController = TextEditingController();
  String selectedDate = '26-10-2003';
  TextEditingController dateController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate as DateTime) {
      selectedDate = picked as String;
      dateController.text = '${picked.month}-${picked.day}-${picked.year}';
    }
  }

  void changeGender({String? value}){
    selectedGender = value!;
    emit(PersonalInformationEditGenderState());
  }

  void save(){
    isEdit = !isEdit;
    emit(PersonalInformationEditState());

  }

  void edit() {
    isEdit = !isEdit;
    if (!isEdit) {
      fName = fNameController.text;
      lName = lNameController.text;
      mail = emailController.text;
      selectedDate = dateController.text;
    } else {
      fNameController.text = fName;
      lNameController.text = lName;
      emailController.text = mail;
      dateController.text = selectedDate;
    }
    emit(PersonalInformationEditState());
  }
}
