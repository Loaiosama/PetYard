import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/widgets/loading_button.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/widgets/first_section.dart';

import '../../../../../../core/utils/theming/styles.dart';
import '../view_model/choose_types_cubit/grooming_cubit.dart';

class ChooseGroomingTypeScreen extends StatelessWidget {
  const ChooseGroomingTypeScreen(
      {super.key, required this.serviceName, required this.groomingTypes});
  final String serviceName;
  final List<dynamic> groomingTypes;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroomingCubit, GroomingState>(
      listener: (context, state) {
        if (state is GroomingTypesSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage),
            ),
          );
          // GoRouter.of(context).push(Routes.kAvailableSlotsScreen, extra: {
          //   "serviceName": serviceName,
          //   "groomingTypes": groomingTypes
          // });

          GoRouter.of(context).push(Routes.kHomeScreen, extra: 0);
        } else if (state is GroomingTypesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<GroomingCubit>(context);
        var filteredTypes = cubit.getFilteredGroomingTypes(groomingTypes);
        // print('Filtereddd $filteredTypes');
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  // print('groomingTypes $groomingTypes');
                  // print('object $filteredTypes');
                  GoRouter.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          body: Padding(
            padding: EdgeInsets.only(
              right: 16.0.w,
              left: 18.0.w,
              top: 10.0.h,
              bottom: 50.h,
            ),
            child: Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FirstSection(
                    title: 'Welcome!',
                    subTitle:
                        'Choose one or more grooming types you want to provide and set their prices. You can always update these later.',
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView.builder(
                      // itemCount: cubit.groomingTypes.length,
                      itemCount: filteredTypes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            cubit.clickGroomingType(index);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.all(16.h),
                            decoration: BoxDecoration(
                              color: cubit.selectedTypes[index]
                                  ? kPrimaryGreen
                                  : Colors.grey.shade200,
                              border: Border.all(
                                color: cubit.selectedTypes[index]
                                    ? kPrimaryGreen
                                    : kSecondaryColor,
                                width:
                                    cubit.selectedTypes[index] ? 2.0.w : 1.0.w,
                              ),
                              borderRadius: BorderRadius.circular(15.0.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // cubit.groomingTypes[index]['type'],
                                  filteredTypes[index]['type'],
                                  style: TextStyle(
                                    color: cubit.selectedTypes[index]
                                        ? kSecondaryColor
                                        : kPrimaryGreen,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (cubit.selectedTypes[index])
                                  TextFormField(
                                    controller: cubit.controllers[index],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Price can\'t be empty!';
                                      }
                                      final price = double.tryParse(value);
                                      if (price == null || price == 0.0) {
                                        return 'Please enter a valid price greater than 0.0';
                                      }
                                      return null;
                                    },
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    onChanged: (value) {
                                      final price = double.parse(value);
                                      cubit.setGroomingTypePrice(index, price);
                                    },
                                    decoration: InputDecoration(
                                      hintText: cubit.groomingTypes[index]
                                              ['price']
                                          .toString(),
                                      labelText: 'Enter price',
                                      labelStyle: const TextStyle(
                                          color: kSecondaryColor),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kSecondaryColor),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kPrimaryGreen),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (state is GroomingTypesLoading)
                    const LoadingButton(
                      height: 60,
                    )
                  else
                    PetYardTextButton(
                      onPressed: () {
                        if (cubit.selectedTypes.contains(true)) {
                          if (cubit.formKey.currentState!.validate()) {
                            List<Map<String, dynamic>> selectedTypes = [];
                            for (int i = 0;
                                i < cubit.selectedTypes.length;
                                i++) {
                              if (cubit.selectedTypes[i]) {
                                final priceStr = cubit.controllers[i].text;
                                final price = double.tryParse(priceStr);
                                if (price != null && price > 0.0) {
                                  selectedTypes.add({
                                    'type': filteredTypes[i]['type'],
                                    'price': price,
                                  });
                                }
                              }
                            }
                            // print('object');
                            // print(selectedTypes);
                            // print(selectedTypes[0]['type']);
                            // print(selectedTypes[0]['price']);
                            if (selectedTypes.isNotEmpty) {
                              for (int i = 0; i < selectedTypes.length; i++) {
                                cubit.submitGroomingTypes(
                                    groomingType: selectedTypes[i]['type'],
                                    price: selectedTypes[i]['price']);
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'Please enter valid prices for selected types'),
                              ));
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Please select at least one grooming type'),
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
