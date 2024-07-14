import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
// import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/loading_button.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/repos/pet_info_imp.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view_model/cubit/add_pet_info_cubit.dart';
// import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/pet_image.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/reap_item.dart';

class RecapDetails extends StatefulWidget {
  final PetModel petModel;
  const RecapDetails({super.key, required this.petModel});

  @override
  State<RecapDetails> createState() => _RecapDetailsState();
}

class _RecapDetailsState extends State<RecapDetails> {
  XFile? image;

  final ImagePicker _picker = ImagePicker();

  void pickImage(ImageSource source) async {
    var img = await _picker.pickImage(source: source);
    setState(() {
      image = img;
      // widget.petModel.image = File(image!.path);
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
      return const AssetImage('assets/images/default.png'); // Placeholder image
    } else {
      return FileImage(File(image!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.80,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RecapItem(
                      iconData: Icons.pets_rounded,
                      primaryText: 'Name',
                      secondaryText: widget.petModel.name ?? 'N/A',
                    ),
                    SizedBox(height: 20.h),
                    RecapItem(
                      iconData: Icons.type_specimen_rounded,
                      primaryText: 'Type',
                      secondaryText: widget.petModel.type ?? 'N/A',
                    ),
                    SizedBox(height: 20.h),
                    RecapItem(
                      iconData: Icons.category_outlined,
                      primaryText: 'Breed',
                      secondaryText: widget.petModel.breed ?? 'N/A',
                    ),
                    SizedBox(height: 20.h),
                    RecapItem(
                      iconData: Icons.male_rounded,
                      primaryText: 'Gender',
                      secondaryText: widget.petModel.gender ?? 'N/A',
                    ),
                    SizedBox(height: 20.h),
                    RecapItem(
                      iconData: Icons.cake_rounded,
                      primaryText: 'Date of Birth',
                      secondaryText: DateFormat('EEEE, d MMM, yyyy')
                          .format(widget.petModel.dateOfBirth ?? DateTime.now())
                          .toString(),
                    ),
                    SizedBox(height: 20.h),
                    RecapItem(
                      iconData: Icons.home_outlined,
                      primaryText: 'Adoption Date',
                      secondaryText: DateFormat('EEEE, d MMM, yyyy')
                          .format(
                              widget.petModel.adoptionDate ?? DateTime.now())
                          .toString(),
                    ),
                    SizedBox(height: 20.h),
                    BlocProvider(
                      create: (context) => AddPetInfoCubit(
                          PetInfoRepoImp(apiService: ApiService(dio: Dio()))),
                      child: BlocConsumer<AddPetInfoCubit, AddPetInfoState>(
                        listener: (context, state) {
                          if (state is AddPetInfoSuccess) {
                            GoRouter.of(context)
                                .push(Routes.kHomeScreen, extra: 4);
                            // GoRouter.of(context)
                            //     .push(Routes.kHomeScreen, extra: 4);
                            // return Text(state.successMessage);
                          } else if (state is AddPetInfoFaliure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.errorMessage)));
                          }
                        },
                        builder: (context, state) {
                          AddPetInfoCubit cubit = BlocProvider.of(context);
                          if (state is AddPetInfoloading) {
                            return LoadingButton(
                              height: 50.h,
                            );
                          }
                          return PetYardTextButton(
                            height: 50.h,
                            width: double.infinity,
                            text: 'Continue',
                            onPressed: () {
                              if (image == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please upload your pet image.')));
                                return;
                              } else {
                                cubit.addPetInfo(
                                  adoptionDate: widget.petModel.adoptionDate!,
                                  bio: widget.petModel.bio!,
                                  dateOfBirth: widget.petModel.dateOfBirth!,
                                  breed: widget.petModel.breed!,
                                  gender: widget.petModel.gender!,
                                  image: File(image!.path),
                                  petModel: widget.petModel,
                                  name: widget.petModel.name!,
                                  type: widget.petModel.type!,
                                  weight: widget.petModel.weight!,
                                );
                              }
                            },
                            style: Styles.styles14NormalBlack
                                .copyWith(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.80 - 72.0,
              left: MediaQuery.of(context).size.width * 0.5 - 63.0,
              child: Align(
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
            ),
          ],
        ),
      ],
    );
  }
}
