import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/widgets/loading_button.dart';
import 'package:petprovider_frontend/features/registration/signin/presentation/view_model/signin_cubit/sign_in_cubit.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/widgets/first_section.dart';

import '../../../../../../core/utils/theming/styles.dart';
import '../../../../../../core/widgets/petyard_text_button.dart';

class ChooseService extends StatelessWidget {
  const ChooseService({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SelectServiceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('service added successfully'),
            ),
          );
          GoRouter.of(context).push(Routes.kHomeScreen, extra: 0);
        } else if (state is SelectServiceFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<SignInCubit>(context);
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                right: 16.0.w,
                left: 18.0.w,
                top: 50.0.h,
                bottom: 70.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FirstSection(
                    title: 'Welcome!',
                    subTitle:
                        'Choose one or more services you want to provide. And don\'t worry, you can always add more services later.',
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                      ),
                      itemCount: cubit.services.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            cubit.clickService(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: cubit.selectedServices[index]
                                  ? kPrimaryGreen
                                  : Colors.grey.shade200,
                              border: Border.all(
                                color: cubit.selectedServices[index]
                                    ? kPrimaryGreen
                                    : kSecondaryColor,
                                width: cubit.selectedServices[index]
                                    ? 2.0.w
                                    : 1.0.w,
                              ),
                              borderRadius: BorderRadius.circular(15.0.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/${cubit.services[index]['icon']}',
                                  height: 90.h,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  cubit.services[index]['name'],
                                  style: TextStyle(
                                    color: cubit.selectedServices[index]
                                        ? kSecondaryColor
                                        : kPrimaryGreen,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  (state is SelectServiceLoading)
                      ? const LoadingButton(
                          height: 60,
                        )
                      : PetYardTextButton(
                          onPressed: () {
                            List<String> selectedTypes = [];
                            for (int i = 0;
                                i < cubit.selectedServices.length;
                                i++) {
                              if (cubit.selectedServices[i]) {
                                selectedTypes.add(cubit.services[i]['name']);
                              }
                            }
                            if (selectedTypes.isNotEmpty) {
                              // Call select service function based on number of selections
                              for (String type in selectedTypes) {
                                String service = type.replaceAll('Pet ', '');
                                cubit.selectService(service);
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('Please select at least one service'),
                              ));
                            }
                          },
                          text: 'Continue',
                          style: Styles.styles16BoldWhite,
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
