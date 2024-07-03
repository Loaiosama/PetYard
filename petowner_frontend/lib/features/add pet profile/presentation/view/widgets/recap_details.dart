import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/repos/pet_info_imp.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view_model/cubit/add_pet_info_cubit.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/pet_image.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/view/widgets/reap_item.dart';

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
                          }
                        },
                        builder: (context, state) {
                          AddPetInfoCubit cubit = BlocProvider.of(context);
                          if (state is AddPetInfoloading) {
                            return Container(
                              width: double.infinity,
                              height: 50.h,
                              color: kPrimaryGreen,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (state is AddPetInfoFaliure) {
                            return Text(state.errorMessage);
                          }
                          return PetYardTextButton(
                            height: 50.h,
                            width: double.infinity,
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
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.80 - 72.0,
              left: MediaQuery.of(context).size.width * 0.5 - 63.0,
              child: const PetImage(),
            ),
          ],
        ),
      ],
    );
  }
}
