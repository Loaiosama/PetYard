import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/Pet.dart';
import 'package:petprovider_frontend/features/pet%20profile/data/repo/owner_repo_imp.dart';
import 'package:petprovider_frontend/features/pet%20profile/presentation/view%20model/onwer_info_states.dart';
import 'package:petprovider_frontend/features/pet%20profile/presentation/view%20model/owner_inf0_cubit.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:geocoding/geocoding.dart';

class PetProfile extends StatelessWidget {
  final Pet pet;
  final int age;
  final int ownerId;

  const PetProfile(
      {super.key, required this.pet, required this.age, required this.ownerId});

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<String> _codingLocation(double? x, double? y) async {
    if (x != null && y != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(x, y);
      print(placemarks[0].country);
      print(placemarks[0].subAdministrativeArea);
      print(placemarks[0].street);
      print(placemarks[0].locality);
      String loc =
          "${placemarks[0].subAdministrativeArea} ${placemarks[0].locality} ${placemarks[0].street}";
      return loc;
    } else {
      print("Location coordinates are not available.");
      return "No Location";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.60,
              width: double.infinity,
              child: Image.asset(
                'assets/images/profile_pictures/${pet.image}',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 6.0.w, right: 6.0.w, top: 40.0.h),
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
                  SizedBox(height: 120.h),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Material(
                        elevation: 2.0.sp,
                        color: Colors.white,
                        shadowColor: kPrimaryGreen,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.3),
                            strokeAlign: 3,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 30.0.h, right: 20.0.w, left: 20.0.w),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet.name ?? "No Name",
                                  style: Styles.styles18SemiBoldBlack,
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text(
                                      pet.type ?? "No Type",
                                      style: Styles.styles12NormalHalfBlack,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      pet.breed ?? "No breed",
                                      style: Styles.styles12NormalHalfBlack,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  children: [
                                    InfoContainer(
                                      color:
                                          const Color.fromRGBO(184, 81, 98, 1),
                                      title: "Gender",
                                      value: pet.gender ?? "No Gender",
                                    ),
                                    SizedBox(width: 10.w),
                                    InfoContainer(
                                      color:
                                          const Color.fromRGBO(85, 164, 239, 1),
                                      title: "Age",
                                      value: age.toString(),
                                    ),
                                    SizedBox(width: 10.w),
                                    InfoContainer(
                                      color:
                                          const Color.fromRGBO(240, 188, 68, 1),
                                      title: "Weight",
                                      value: pet.weight.toString(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                BlocProvider(
                                  create: (context) => OwnerInfoCubit(
                                    OwnerRepoImp(api: ApiService(dio: Dio())),
                                  )..fetchOwnerInfo(ownerId),
                                  child: BlocBuilder<OwnerInfoCubit,
                                      OwnerInfoState>(
                                    builder: (context, state) {
                                      if (state is OwnerInfoLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: kPrimaryGreen,
                                          ),
                                        );
                                      } else if (state is OwnerInfoFailure) {
                                        return const Center(
                                          child: Icon(Icons.error),
                                        );
                                      } else if (state is OwnerInfoSuccess) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Pet Owner",
                                              style: Styles.styles16BoldBlack
                                                  .copyWith(fontSize: 16),
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: CircleAvatar(
                                                    radius: 27.sp,
                                                    backgroundImage: state
                                                                .owner.image !=
                                                            null
                                                        ? NetworkImage(
                                                            state.owner.image!)
                                                        : null,
                                                    child: state.owner.image ==
                                                            null
                                                        ? const Icon(
                                                            Icons.person)
                                                        : null,
                                                  ),
                                                ),
                                                SizedBox(width: 15.w),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0.sp),
                                                  child: Text(
                                                    "${state.owner.firstName} ${state.owner.lastName}",
                                                    style: Styles
                                                        .styles12NormalHalfBlack
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _codingLocation(
                                                          state.owner.location
                                                              ?.x,
                                                          state.owner.location
                                                              ?.y);
                                                      context.pushNamed(
                                                          Routes
                                                              .KPetOwnerProfile,
                                                          extra: {
                                                            'onwer':
                                                                state.owner,
                                                            'pet': pet,
                                                          });
                                                    },
                                                    child: Container(
                                                      width: 120.w,
                                                      height: 40.h,
                                                      decoration: BoxDecoration(
                                                        color: kPrimaryGreen,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "View Profile",
                                                          style: Styles
                                                              .styles14NormalBlack
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Text(
                                  "About ${pet.name}",
                                  style: Styles.styles16w600
                                      .copyWith(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Text(
                                  "${pet.bio}",
                                  style: Styles.styles12NormalHalfBlack,
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Text(
                                  "Adoption Date",
                                  style: Styles.styles16w600
                                      .copyWith(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.calendar,
                                      color: kPrimaryGreen,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      pet.adoptionDate != null
                                          ? _formatDate(pet.adoptionDate!)
                                          : "Adoption Date Is Not Available",
                                      style: Styles.styles12NormalHalfBlack,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Text(
                                  "Date Of Birth",
                                  style: Styles.styles16w600
                                      .copyWith(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.calendar,
                                      color: kPrimaryGreen,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      pet.dateOfBirth != null
                                          ? _formatDate(pet.dateOfBirth!)
                                          : "Birth Date Is Not Available",
                                      style: Styles.styles12NormalHalfBlack,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  final String title;
  final Color color;
  final String value;

  const InfoContainer({
    super.key,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 140.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.r),
        color: color,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 75.0.sp,
            right: 4.sp,
            child: Transform.rotate(
              angle: -0.4,
              child: Icon(
                FontAwesomeIcons.paw,
                color: Colors.white.withOpacity(0.3),
                size: 46.0.sp,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: Styles.styles16w600.copyWith(
                  color: Colors.white,
                ),
              ),
              StrokeText(
                text: value,
                textStyle:
                    Styles.styles16BoldBlack.copyWith(color: Colors.white),
                strokeWidth: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
