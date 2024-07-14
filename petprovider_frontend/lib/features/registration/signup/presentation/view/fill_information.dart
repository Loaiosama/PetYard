import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/widgets/first_section.dart';

import '../../../../../core/utils/networking/api_service.dart';
import '../../../../../core/utils/routing/routes.dart';
import '../../../../../core/utils/theming/colors.dart';
import '../../../../../core/utils/theming/styles.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../core/widgets/petyard_text_button.dart';
import '../../data/repo/signup_repo.dart';
import '../view model/cubit/sign_up_cubit.dart';
import 'widgets/date_of_birth_column.dart';
import 'widgets/signup_text_field_column.dart';

class FillInformationSignUp extends StatefulWidget {
  const FillInformationSignUp({
    super.key,
    required this.userName,
    required this.email,
    required this.password,
  });

  final String userName;
  final String email;
  final String password;

  @override
  State<FillInformationSignUp> createState() => _FillInformationSignUpState();
}

class _FillInformationSignUpState extends State<FillInformationSignUp> {
  final formKey = GlobalKey<FormState>();

  static TextEditingController fullNameController = TextEditingController();
  static TextEditingController dateOfBirthController = TextEditingController();
  static TextEditingController phoneNumberController = TextEditingController();
  static TextEditingController bioController = TextEditingController();

  XFile? image;
  final ImagePicker _picker = ImagePicker();

  void pickImage(ImageSource source) async {
    var img = await _picker.pickImage(source: source);
    setState(() {
      image = img;
    });
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  leading: const Icon(Iconsax.camera),
                  title: const Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  leading: const Icon(Iconsax.gallery),
                  title: const Text('Gallery'),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider<Object>? _getImageProvider() {
    if (image == null) {
      return const AssetImage('assets/images/1.png'); // Placeholder image
    } else {
      return FileImage(File(image!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          right: 16.0.w,
          left: 18.0.w,
          top: 50.0.h,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FirstSection(
                    title: 'Fill Your Profile',
                    subTitle:
                        'Please take a few minutes to fill out your profile with as much detail as possible.',
                  ),
                  heightSizedBox(30),
                  Align(
                    child: Container(
                      width: 130.0.w,
                      height: 130.0.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _getImageProvider()!,
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 4.0.w,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 34.w,
                          height: 34.h,
                          margin: EdgeInsets.only(top: 40.0.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 4.0.w,
                            ),
                            shape: BoxShape.circle,
                            color: const Color.fromRGBO(248, 248, 248, 1),
                          ),
                          child: IconButton(
                            onPressed: () => _showPicker(context),
                            icon: Center(
                              child: Icon(
                                FontAwesomeIcons.penToSquare,
                                size: 13.sp,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  heightSizedBox(18),
                  SignUpTextFieldColumn(
                    hintText: 'Full Name',
                    controller: fullNameController,
                  ),
                  heightSizedBox(12),
                  SignUpTextFieldColumn(
                    controller: phoneNumberController,
                    hintText: '+20 | Phone Number',
                    keyboardType: TextInputType.phone,
                    isPhone: true,
                  ),
                  heightSizedBox(12),
                  TextFormField(
                    controller: bioController,
                    maxLines: 5,
                    minLines: 2,
                    decoration: InputDecoration(
                      hintText: 'About Me',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14.sp,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                        borderSide: const BorderSide(
                          // color: Color.fromRGBO(0, 170, 91, 1),
                          color: kPrimaryGreen,
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.2),
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your bio';
                      }
                      return null;
                    },
                  ),
                  // SignUpTextFieldColumn(
                  //   hintText: 'About me',
                  //   controller: fullNameController,
                  // ),
                  heightSizedBox(14),
                  DateOfBirthColumn(
                    controller: dateOfBirthController,
                  ),
                  heightSizedBox(30),
                  BlocProvider(
                    create: (context) =>
                        SignUpCubit(SignUpRepo(api: ApiService(dio: Dio()))),
                    child: BlocConsumer<SignUpCubit, SignUpState>(
                      builder: (context, state) {
                        var cubit = BlocProvider.of<SignUpCubit>(context);
                        if (state is SignUpLoading) {
                          return const LoadingButton(
                            height: 60,
                            radius: 10,
                          );
                        }
                        return PetYardTextButton(
                          onPressed: () {
                            // print('1 n ${image?.path}');
                            // print(FileImage(File(image!.path)));
                            // File imageFile = File(image!.path);
                            // print(image?.path);

                            // GoRouter.of(context).push(Routes.kChooseService);

                            if (image?.path == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('please upload your image.')));
                            }
                            if (formKey.currentState!.validate()) {
                              // print('2 n ${image?.path}');
                              // print(FileImage(File(image!.path)));
                              // print('==== ${File(image!.path)}');
                              // // File imageFile = File(image!.path);
                              // print(image?.path);
                              cubit.signUp(
                                userName: widget.userName,
                                bio: bioController.text,
                                image: File(image!.path),
                                // Pass the File type
                                email: widget.email,
                                pass: widget.password,
                                phoneNumber: phoneNumberController.text,
                                dateOfBirth: dateOfBirthController.text,
                              );
                            }
                          },
                          style: Styles.styles16BoldWhite,
                        );
                      },
                      listener: (context, state) {
                        if (state is SignUpFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage)));
                        } else if (state is SignUpSuccess) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('SignUp Successful')),
                          // );
                          // // Navigate to the home screen
                          // GoRouter.of(context).push(Routes.kSigninScreen);
                          print(widget.email);
                          GoRouter.of(context).push(Routes.kValidationCode,
                              extra: widget.email);
                          // GoRouter.of(context).push(Routes.kChooseService);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
