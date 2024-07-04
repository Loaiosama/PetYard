import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo.dart';
import 'package:petowner_frontend/features/profile/data/repo/profile_repo_impl.dart';

part 'personal_information_state.dart';

class PersonalInformationCubit extends Cubit<PersonalInformationState> {
  PersonalInformationCubit() : super(PersonalInformationInitial()) {
    fNameController = TextEditingController(text: fName);
    lNameController = TextEditingController(text: lName);
    emailController = TextEditingController(text: mail);
    dateController = TextEditingController(text: selectedDate);
    phoneNumberController = TextEditingController(text: phoneNumber);
  }

  bool isEdit = false;
  String fName = '';
  String lName = '';
  String phoneNumber = '';
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String mail = '';
  TextEditingController emailController = TextEditingController();
  String selectedGender = '';
  TextEditingController genderController = TextEditingController();
  String selectedDate = '';
  TextEditingController dateController = TextEditingController();

  static ProfileRepo profileRepo =
      ProfileRepoImpl(apiService: ApiService(dio: Dio()));

  Future<void> getOwnerInfo() async {
    var result = await profileRepo.getOwnerInfo();
    result.fold((failure) {
      // Handle failure case
    }, (ownerInfo) {
      fName = ownerInfo.data?.firstName ?? '';
      lName = ownerInfo.data?.lastName ?? '';
      mail = ownerInfo.data?.email ?? '';
      phoneNumber = ownerInfo.data?.phone ?? '';
      // Format date using DateFormat from intl package
      selectedDate = ownerInfo.data?.dateOfBirth != null
          ? DateFormat('dd-MM-yyyy')
              .format(ownerInfo.data!.dateOfBirth!.toLocal())
          : '';

      fNameController.text = fName;
      lNameController.text = lName;
      emailController.text = mail;
      dateController.text = selectedDate;
      phoneNumberController.text = phoneNumber;
      emit(PersonalInformationLoadedState());
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // Format date using DateFormat from intl package
      selectedDate = DateFormat('dd-MM-yyyy').format(picked.toLocal());
      dateController.text = selectedDate;
      emit(PersonalInformationDateSelectedState());
    }
  }

  // void changeGender({String? value}) {
  //   selectedGender = value!;
  //   emit(PersonalInformationEditGenderState());
  // }

  void save() {
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

  Future<void> updateOwnerInformation({
    required String firstName,
    required String lastName,
    required String pass,
    required String email,
    required String phoneNumber,
    required DateTime dateOfBirth,
  }) async {
    emit(UpdateOwnerInformationLoading());
    await Future.delayed(const Duration(seconds: 1));

    try {
      bool isSuccess = await profileRepo.updateOwnerInfo(
        firstName: firstName,
        lastName: lastName,
        pass: pass,
        email: email,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
      );
      // print(isSuccess);
      if (isSuccess) {
        emit(UpdateOwnerInformationSuccess(isSuccess: true));
        await getOwnerInfo();
      } else {
        emit(UpdateOwnerInformationFailure(isFail: true));
      }
    } catch (e) {
      emit(UpdateOwnerInformationFailure(isFail: true));
    }
  }
}
