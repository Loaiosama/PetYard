import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/pet%20profile/data/repos/pet_info_imp.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/view_model/cubit/add_pet_info_cubit.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/pet_image.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/reap_item.dart';

class RecapDetails extends StatelessWidget {
  final PetModel petModel;
  const RecapDetails({super.key, required this.petModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 660.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RecapItem(
                    iconData: Icons.pets_rounded,
                    primaryText: 'Name',
                    secondaryText: petModel.name ?? 'N/A',
                  ),
                  SizedBox(height: 20.h),
                  RecapItem(
                    iconData: Icons.type_specimen_rounded,
                    primaryText: 'Type',
                    secondaryText: petModel.type ?? 'N/A',
                  ),
                  SizedBox(height: 20.h),
                  RecapItem(
                    iconData: Icons.category_outlined,
                    primaryText: 'Breed',
                    secondaryText: petModel.breed ?? 'N/A',
                  ),
                  SizedBox(height: 20.h),
                  RecapItem(
                    iconData: Icons.male_rounded,
                    primaryText: 'Gender',
                    secondaryText: petModel.gender ?? 'N/A',
                  ),
                  SizedBox(height: 20.h),
                  RecapItem(
                    iconData: Icons.cake_rounded,
                    primaryText: 'Date of Birth',
                    secondaryText: petModel.dateOfBirth ?? 'N/A',
                  ),
                  SizedBox(height: 20.h),
                  RecapItem(
                    iconData: Icons.home_outlined,
                    primaryText: 'Adoption Date',
                    secondaryText: petModel.adoptionDate ?? 'N/A',
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: BlocProvider(
                      create: (context) => AddPetInfoCubit(
                          PetInfoRepoImp(apiService: ApiService(dio: Dio()))),
                      child: BlocBuilder<AddPetInfoCubit, AddPetInfoState>(
                        builder: (context, state) {
                          AddPetInfoCubit cubit = BlocProvider.of(context);
                          if (state is AddPetInfoSuccess) {
                            return Text(state.successMessage);
                          } else if (state is AddPetInfoloading) {
                            return const CircularProgressIndicator();
                          } else if (state is AddPetInfoFaliure) {
                            return Text(state.errorMessage);
                          }
                          return PetYardTextButton(
                            width: 50.w,
                            text: 'Continue',
                            onPressed: () {
                              cubit.addPetInfo(petModel);
                            },
                            style: Styles.styles14NormalBlack
                                .copyWith(color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              top: -80,
              child: PetImage(),
            ),
          ],
        ),
      ],
    );
  }
}
