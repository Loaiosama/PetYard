import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/pet_carer_card.dart';
import 'package:petowner_frontend/features/profile/data/repo/get_all_pets_repo.dart';
import 'package:petowner_frontend/features/profile/presentation/view_model/pet%20info/pet_info_cubit.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:intl/intl.dart';

class PetInformationScreen extends StatelessWidget {
  const PetInformationScreen({super.key, required this.id});
  final int id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PetInfromationScreenBody(
        id: id,
      ),
    );
  }
}

class PetInfromationScreenBody extends StatelessWidget {
  const PetInfromationScreenBody({super.key, required this.id});
  final int id;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetInfoCubit(
        ProfileRepoImpl(
          apiService: ApiService(
            dio: Dio(),
          ),
        ),
      )..getPetInfo(id: id),
      child: BlocBuilder<PetInfoCubit, PetInfoState>(
        builder: (context, state) {
          if (state is PetInfoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PetInfoFailure) {
            return Text(state.errorMessage);
          } else if (state is PetInfoSuccess) {
            // String age = DataTime();
            DateFormat dateFormat = DateFormat('dd-MM-yyyy');
            String formattedDate =
                dateFormat.format(state.petModel.data![0].adoptionDate!);
            return Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.39,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/${state.petModel.data![0].image}',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 6.0.w, right: 6.0.w, top: 40.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      heightSizedBox(200),
                      Expanded(
                        child: Material(
                          elevation: 2.0,
                          color: Colors.white,
                          shadowColor: kPrimaryGreen,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.r),
                              topRight: Radius.circular(30.r),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.3),
                              width: 1.0,
                              strokeAlign: 3,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 20.0.h, right: 20.0.w, left: 20.0.w),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.petModel.data?[0].name ??
                                                'no name',
                                            style: Styles.styles18BoldBlack,
                                          ),
                                          Text(
                                            state.petModel.data?[0].breed ??
                                                'no breed',
                                            style:
                                                Styles.styles12NormalHalfBlack,
                                          ),
                                          heightSizedBox(2),
                                          const RatingRowWidget()
                                        ],
                                      ),
                                      Material(
                                        elevation: 1.0,
                                        shape: const CircleBorder(),
                                        child: Tooltip(
                                          message: 'Delete Pet Profile',
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.trash,
                                              color: Colors.redAccent,
                                              size: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  heightSizedBox(16),
                                  AgeGenderWeightRow(
                                    weight:
                                        state.petModel.data![0].weight ?? 2.0,
                                    gender: state.petModel.data![0].gender ??
                                        'no gender',
                                    age: state.age,
                                  ),
                                  heightSizedBox(16),
                                  Text(
                                    'About Maxi',
                                    style: Styles.styles14w600,
                                  ),
                                  heightSizedBox(8),
                                  Text(
                                    'About my pet.',
                                    style: Styles.styles12NormalHalfBlack,
                                  ),
                                  heightSizedBox(16),
                                  Text(
                                    'Adoption Date',
                                    style: Styles.styles14w600,
                                  ),
                                  heightSizedBox(8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range_outlined,
                                        color: Colors.black.withOpacity(0.4),
                                        size: 18.sp,
                                      ),
                                      widthSizedBox(8),
                                      Text(
                                        formattedDate,
                                        style: Styles.styles12NormalHalfBlack,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('oops!'),
            );
          }
        },
      ),
    );
  }
}

class AgeGenderWeightRow extends StatelessWidget {
  const AgeGenderWeightRow({
    super.key,
    required this.gender,
    required this.age,
    required this.weight,
  });

  final String gender;
  final int age;
  final double weight;

  static List colors = [
    const Color.fromRGBO(184, 81, 98, 1),
    const Color.fromRGBO(85, 164, 239, 1),
    const Color.fromRGBO(240, 188, 68, 1),
  ];
  static List title = [
    'Gender',
    'Age',
    'Weight',
  ];
  List<dynamic> get values => [
        gender,
        age.toString(),
        weight.toString(),
      ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(
          3,
          (index) => Container(
            height: 140.h,
            width: 100.w,
            margin: index < 2 ? EdgeInsets.only(right: 10.w) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(10.0.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // angle: 340 * 3.141592653589793 / 180,
                Padding(
                  padding: EdgeInsets.only(right: 4.0.w, bottom: 2.0.h),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Transform.rotate(
                      angle: 340 * 3.141592653589793 / 180,
                      child: Icon(
                        FontAwesomeIcons.paw,
                        color: Colors.white.withOpacity(0.2),
                        size: 46.0.sp,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title[index],
                      style: Styles.styles16w600.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    StrokeText(
                      text: values[index],
                      textStyle: Styles.styles18BoldBlack.copyWith(
                        color: Colors.white,
                      ),
                      strokeWidth: 0.7,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
