import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/features/grooming/data/repo/grooming_repo_impl.dart';
import 'package:petprovider_frontend/features/grooming/presentation/view_model/edit_types_cubit/edit.types.dart';

class EditGroomingTypesTab extends StatelessWidget {
  final List<dynamic> initialTypes;

  const EditGroomingTypesTab({super.key, required this.initialTypes});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GroomingTypesCubit(GroomingRepoImpl(api: ApiService(dio: Dio()))),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Add Grooming Types', style: Styles.styles16BoldBlack),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // print('initialTypes $initialTypes');
                GoRouter.of(context).push(Routes.kChooseGroomingTypes, extra: {
                  "serviceName": "Grooming",
                  "groomingTypes": initialTypes,
                });
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: initialTypes.length,
          itemBuilder: (context, index) {
            TextEditingController priceController =
                TextEditingController(text: '${initialTypes[index]['price']}');

            return Card(
              color: Colors.grey.shade300,
              margin: EdgeInsets.symmetric(vertical: 8.0.h),
              child: ListTile(
                title: Text(
                  initialTypes[index]['grooming_type'],
                  style: Styles.styles14NormalBlack,
                ),
                subtitle: Text('${initialTypes[index]['price']}/EGP'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocConsumer<GroomingTypesCubit, GroomingTypesState>(
                      listener: (context, state) {
                        if (state is EditPriceSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Price updated successfully!'),
                            ),
                          );
                          GoRouter.of(context)
                              .push(Routes.kHomeScreen, extra: 0);
                        } else if (state is EditPriceFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        var cubit =
                            BlocProvider.of<GroomingTypesCubit>(context);
                        return IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.penToSquare,
                            color: kPrimaryGreen,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Edit Price'),
                                  content: TextFormField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ], // Allow only digits
                                    decoration: const InputDecoration(
                                      hintText: 'Enter new price',
                                    ),
                                  ),
                                  actions: [
                                    state is EditPriceLoading
                                        ? const CircularProgressIndicator()
                                        : TextButton(
                                            child: const Text('Save'),
                                            onPressed: () {
                                              cubit.editPrice(
                                                  price: double.parse(
                                                      priceController.text),
                                                  type: initialTypes[index]
                                                      ['grooming_type']);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    BlocListener<GroomingTypesCubit, GroomingTypesState>(
                      listener: (context, state) {
                        if (state is DeleteSucces) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Grooming type deleted successfully')),
                          );
                          GoRouter.of(context)
                              .push(Routes.kHomeScreen, extra: 0);
                        } else if (state is DeleteFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to delete grooming type: ${state.errorMessage}')),
                          );
                        }
                      },
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          var cubit =
                              BlocProvider.of<GroomingTypesCubit>(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this grooming type?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      cubit.deleteGroomingType(
                                          initialTypes[index]['id']);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
