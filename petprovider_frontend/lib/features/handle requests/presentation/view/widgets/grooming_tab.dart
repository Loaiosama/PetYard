import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/empty_list.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/Pet.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/grooming%20repo/grooming_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/handel_req_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/grooming%20reservations%20cubit/grooming_reservation_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/grooming%20reservations%20cubit/grooming_reservation_states.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/pet%20cubit/pet_info_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/pet%20cubit/pet_info_state.dart';

class GroomingTab extends StatefulWidget {
  const GroomingTab({super.key});

  @override
  State<GroomingTab> createState() => _GroomingTabState();
}

class _GroomingTabState extends State<GroomingTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GroomingReservationCubit(GroomingRepoImp(api: ApiService(dio: Dio())))
            ..fetchGroomingReservations(),
      child: BlocBuilder<GroomingReservationCubit, GroomingReservationState>(
        builder: (context, state) {
          if (state is GroomingReservationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GroomingReservationFailure) {
            return Center(child: Text('No reservations for now'));
          } else if (state is GroomingReservationSucsses) {
            if (state.reservations.isNotEmpty) {
              return ListView.builder(
                itemCount: state.reservations.length,
                itemBuilder: (context, index) {
                  var reservation = state.reservations[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 10.0,
                    ),
                    child: Material(
                      color: Colors.white,
                      elevation: 3.0.sp,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10.0.sp, top: 10.0.sp, bottom: 10.0.sp),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                BlocProvider(
                                  create: (context) => PetInfoCubit(
                                      PetInfoInitial(),
                                      HandelReqRepoImp(
                                          api: ApiService(dio: Dio())))
                                    ..fetchPetInfo(id: reservation.petId!),
                                  child:
                                      BlocBuilder<PetInfoCubit, PetInfoState>(
                                    builder: (context, petState) {
                                      if (petState is PetInfoLoading) {
                                        return CircleAvatar(
                                          radius: 30.sp,
                                          child:
                                              const CircularProgressIndicator(),
                                        );
                                      } else if (petState is PetInfoSuccess) {
                                        return GestureDetector(
                                          onTap: () {
                                            Pet pet = petState.pet;
                                            int age = petState.age;
                                            int ownerId = pet.ownerId!;

                                            context.pushNamed(
                                                Routes.KPetProfile,
                                                extra: {
                                                  'pet': pet,
                                                  'age': age,
                                                  'ownerId':
                                                      ownerId // Pass ownerId here
                                                });

                                            print("b3d el push");
                                          },
                                          child: CircleAvatar(
                                            radius: 30.sp,
                                            backgroundImage: NetworkImage(
                                              petState.pet.image ?? " ",
                                            ),
                                          ),
                                        );
                                      } else if (petState is PetInfofaliure) {
                                        return CircleAvatar(
                                          radius: 30.sp,
                                          child: const Icon(Icons.error),
                                        );
                                      } else {
                                        return CircleAvatar(
                                          radius: 30.sp,
                                          child: const Icon(Icons.pets),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${DateFormat('d MMM yyyy hh:mm a').format(reservation.startTime!)}",
                                        style: Styles.styles12NormalHalfBlack),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/Grooming.png",
                                          width: 20.w,
                                          height: 20.h,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          "Grooming",
                                          style: Styles.styles14NormalBlack,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      "${reservation.finalPrice} EGP",
                                      style: Styles.styles16BoldBlack
                                          .copyWith(color: Colors.green),
                                    ),
                                    /*SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      "${reservation.ownerFirstName} ${reservation.ownerLastName}",
                                      style: Styles.styles12NormalHalfBlack,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      "${reservation.ownerPhone}",
                                      style: Styles.styles12NormalHalfBlack,
                                    )*/
                                  ],
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Text(
                                  "Reserved",
                                  style: Styles.styles16BoldBlack
                                      .copyWith(color: Colors.green),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const EmptyList(service: "Walking", type: "Reservations");
            }
          } else {
            return const Center(child: Text('Initial State'));
          }
        },
      ),
    );
  }
}
