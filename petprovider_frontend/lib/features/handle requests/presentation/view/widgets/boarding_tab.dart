import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/Pet.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/boarding_reservation.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/model/reservation_update.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/boarding_repo/boarding_reservation_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/data/repo/handel_req_repo_imp.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20cubit/apply_req_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/apply%20cubit/apply_req_states.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/boarding%20reservation%20cubit/boarding_reservation_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/boarding%20reservation%20cubit/boarding_reservation_state.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/pet%20cubit/pet_info_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/pet%20cubit/pet_info_state.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/update%20reservation%20cubit/update_reservation_cubit.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view%20model/update%20reservation%20cubit/update_reservation_state.dart';

class BoardingTab extends StatefulWidget {
  const BoardingTab({super.key});

  @override
  _BoardingTabState createState() => _BoardingTabState();
}

class _BoardingTabState extends State<BoardingTab> {
  final Set<int> appliedReservations = {};
  final Map<int, String> reservationStatuses =
      {}; // To keep track of the statuses

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardingReservationCubit(
          BoardingReservationRepoImp(api: ApiService(dio: Dio())))
        ..fetchReservations(),
      child: BlocBuilder<BoardingReservationCubit, BoardingReservationState>(
        builder: (context, state) {
          if (state is BoardingReservationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BoardingReservationFailure) {
            return Center(child: Text('No reservations for now'));
          } else if (state is BoardingReservationSuccess) {
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
                                child: BlocBuilder<PetInfoCubit, PetInfoState>(
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
                                          int id = reservation.ownerId;
                                          print(age);
                                          print(pet.name);

                                          int ownerId = reservation
                                              .ownerId; // Add this line

                                          context.pushNamed(Routes.KPetProfile,
                                              extra: {
                                                'pet': pet,
                                                'age': age,
                                                'ownerId':
                                                    ownerId, // Pass ownerId here
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
                                      "${DateFormat('dd.MMM').format(reservation.startTime)} | ${DateFormat('dd.MMM').format(reservation.endTime)}",
                                      style: Styles.styles12NormalHalfBlack),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/boarding.png",
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "Boarding",
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
                                ],
                              ),
                              SizedBox(
                                width: 40.w,
                              ),
                              BlocProvider(
                                create: (context) => ApplyReservationCubit(
                                    BoardingReservationRepoImp(
                                        api: ApiService(dio: Dio()))),
                                child: BlocConsumer<ApplyReservationCubit,
                                    ApplyReservationState>(
                                  builder: (context, resState) {
                                    if (appliedReservations.contains(index)) {
                                      String? type = reservationStatuses[index];
                                      if (type == "Accepted") {
                                        return Text(
                                          "Accepted",
                                          style: Styles.styles16BoldBlack
                                              .copyWith(color: Colors.green),
                                        );
                                      } else {
                                        return Text(
                                          "Rejected",
                                          style: Styles.styles16BoldBlack
                                              .copyWith(color: Colors.red),
                                        );
                                      }
                                    } else {
                                      if (resState is ApplyReservationLoading) {
                                        return const CircularProgressIndicator(
                                          color: kPrimaryGreen,
                                        );
                                      } else if (resState
                                          is ApplyRequestFailure) {
                                        return const Icon(Icons.error);
                                      } else {
                                        return Column(
                                          children: [
                                            PetYardTextButton(
                                              onPressed: () {
                                                ReservationUpdate
                                                    reservationUpdate =
                                                    ReservationUpdate(
                                                        slotId:
                                                            reservation.slotId,
                                                        petId:
                                                            reservation.petId,
                                                        ownerId:
                                                            reservation.ownerId,
                                                        startTime: reservation
                                                            .startTime,
                                                        endTime:
                                                            reservation.endTime,
                                                        type: "Accepted");
                                                BlocProvider.of<
                                                            ApplyReservationCubit>(
                                                        context)
                                                    .applyReservation(
                                                        reservation.reserveId,
                                                        reservationUpdate);
                                                setState(() {
                                                  appliedReservations
                                                      .add(index);
                                                  reservationStatuses[index] =
                                                      "Accepted";
                                                });
                                              },
                                              text: "Accept",
                                              style: Styles
                                                  .styles12NormalHalfBlack
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                              color: Colors.green,
                                              width: 42.w,
                                              radius: 8.r,
                                              height: 15.h,
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            PetYardTextButton(
                                              onPressed: () {
                                                ReservationUpdate
                                                    reservationUpdate =
                                                    ReservationUpdate(
                                                        slotId:
                                                            reservation.slotId,
                                                        petId:
                                                            reservation.petId,
                                                        ownerId:
                                                            reservation.ownerId,
                                                        startTime: reservation
                                                            .startTime,
                                                        endTime:
                                                            reservation.endTime,
                                                        type: "Rejected");
                                                BlocProvider.of<
                                                            ApplyReservationCubit>(
                                                        context)
                                                    .applyReservation(
                                                        reservation.reserveId,
                                                        reservationUpdate);
                                                setState(() {
                                                  appliedReservations
                                                      .add(index);
                                                  reservationStatuses[index] =
                                                      "Rejected";
                                                });
                                              },
                                              text: " Reject ",
                                              style: Styles
                                                  .styles12NormalHalfBlack
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                              color: Color.fromARGB(
                                                  255, 230, 25, 11),
                                              width: 46.w,
                                              radius: 8.r,
                                              height: 15.h,
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  },
                                  listener: (context, state) {
                                    if (state is ApplyReservationSuccess) {
                                      // Perform any additional actions on success
                                    }
                                  },
                                ),
                              ),
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
            return const Center(child: Text('Initial State'));
          }
        },
      ),
    );
  }
}
