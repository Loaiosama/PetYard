import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/features/home/data/repo/home_repo_impl.dart';
import 'package:petprovider_frontend/features/home/presentation/view%20model/profile_info_cubit/profile_info_cubit.dart';

class BoardingSlotsTab extends StatelessWidget {
  const BoardingSlotsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0.w),
      child: Column(
        children: [
          BlocProvider(
            create: (context) =>
                ProfileInfoCubit(HomeRepoImppl(api: ApiService(dio: Dio())))
                  ..fetchProviderSlots(),
            child: BlocConsumer<ProfileInfoCubit, ProfileInfoState>(
              listener: (context, state) {
                if (state is DeleteSlotSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Deleted Successfully'),
                    ),
                  );
                } else if (state is DeleteSlotFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.isSuccess),
                    ),
                  );
                }
              },
              builder: (context, state) {
                var cubit = BlocProvider.of<ProfileInfoCubit>(context);
                if (state is ProviderSlotSuccess) {
                  var info = state.slots;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: info.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 10.0.h),
                          child: Dismissible(
                            background: Container(
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            key: ValueKey<int>(info[index].slotId ?? -1),
                            onDismissed: (direction) {
                              showDialog(
                                context: context,
                                builder: (alertcontext) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      'Delete Slot?',
                                      style: Styles.styles16BoldBlack.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete this Slot?',
                                      style: Styles.styles12NormalHalfBlack,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          GoRouter.of(alertcontext).pop();
                                          // cubit.fetchProviderSlots();
                                        },
                                        child: const Text(
                                          'No, back.',
                                          style: TextStyle(
                                            color: kPrimaryGreen,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          cubit.deleteProviderSlotById(
                                              id: info[index].slotId ?? -1);
                                          cubit.fetchProviderSlots();
                                          GoRouter.of(alertcontext).pop();
                                          // cubit.fetchProviderSlots();
                                        },
                                        child: const Text(
                                          'Yes, Delete!',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                    shape: ContinuousRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0.r),
                                    ),
                                  );
                                },
                              );
                              // cubit.deleteProviderSlotById(
                              //     id: info[index].slotId ?? -1);
                              cubit.fetchProviderSlots();
                              // print(ValueKey<int>(info[index].slotId ?? -1));
                            },
                            child: Material(
                              color: kSecondaryColor.withOpacity(0.8),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(10.0.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0.w, vertical: 14.0.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${info[index].slotId}'),
                                    Row(
                                      children: [
                                        Text(
                                          'Start time: ${DateFormat('EEEE, d MMM, yyyy').format(info[index].startTime!)}',
                                          style: Styles.styles14NormalBlack,
                                        ),
                                      ],
                                    ),
                                    heightSizedBox(6),
                                    Row(
                                      children: [
                                        Text(
                                          'End time: ${DateFormat('EEEE, d MMM, yyyy').format(info[index].endTime!)}',
                                          style: Styles.styles14NormalBlack,
                                        ),
                                      ],
                                    ),
                                    heightSizedBox(6),
                                    Row(
                                      children: [
                                        Text(
                                          'Price: ${info[index].price}/EGP',
                                          style: Styles.styles14NormalBlack,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is ProviderSlotFailure) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else if (state is ProviderSlotLoading) {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.30),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryGreen,
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.30),
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          cubit.fetchProviderSlots();
                        },
                        child: const Text('Refresh')),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
