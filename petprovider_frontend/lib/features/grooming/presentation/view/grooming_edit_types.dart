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

// class EditGroomingTypesTab extends StatelessWidget {
//   final List<dynamic> initialTypes;
//   final GroomingRepoImpl groomingRepoImpl;

//   const EditGroomingTypesTab({
//     Key? key,
//     required this.initialTypes,
//     required this.groomingRepoImpl,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// appBar: AppBar(
//   automaticallyImplyLeading: false,
//   title: Text('Edit Grooming Types', style: Styles.styles16BoldBlack),
//   actions: [
//     IconButton(
//       icon: const Icon(Icons.add),
//       onPressed: () {
//         _showAddTypeModal(context);
//       },
//     ),
//   ],
// ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0.w),
//         child: BlocProvider(
//           create: (context) =>
//               GroomingTypesCubit(groomingRepoImpl)..initialize(initialTypes),
//           child: BlocBuilder<GroomingTypesCubit, GroomingTypesState>(
//             builder: (context, state) {
//               if (state is GroomingTypesLoaded ||
//                   state is GroomingTypesUpdated) {
//                 final types = state is GroomingTypesLoaded
//                     ? state.types
//                     : (state as GroomingTypesUpdated).types;
//                 return ListView.builder(
//                   itemCount: types.length,
//                   itemBuilder: (context, index) {
//                     final groomingType = types[index];
//                     return Card(
//                       color: Colors.grey.shade300,
//                       margin: EdgeInsets.symmetric(vertical: 8.0.h),
//                       child: ListTile(
//                         title: Text(
//                           groomingType['grooming_type'],
//                           style: Styles.styles14NormalBlack,
//                         ),
//                         subtitle: Text('${groomingType['price']}/EGP'),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(
//                                 FontAwesomeIcons.penToSquare,
//                                 color: kPrimaryGreen,
//                               ),
//                               onPressed: () {
//                                 _showEditTypeModal(context, index);
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.delete,
//                                 color: Colors.red,
//                               ),
//                               onPressed: () {
//                                 context
//                                     .read<GroomingTypesCubit>()
//                                     .removeGroomingType(index);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               } else if (state is GroomingTypesLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else {
//                 return const Center(child: Text('Something went wrong!'));
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAddTypeModal(BuildContext context) {
//     final cubit = context.read<GroomingTypesCubit>();
//     final state = cubit.state as GroomingTypesLoaded;
//     final TextEditingController priceController = TextEditingController();
//     Map<String, dynamic>? selectedType;

//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.all(16.0.w),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               DropdownButtonFormField<Map<String, dynamic>>(
//                 items: state.excludedTypes.map((type) {
//                   return DropdownMenuItem(
//                     value: type,
//                     child: Text(type['type']),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   selectedType = value;
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Select Grooming Type',
//                 ),
//               ),
//               TextField(
//                 controller: priceController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: 'Price'),
//               ),
//               SizedBox(height: 16.h),
//               ElevatedButton(
//                 onPressed: () {
//                   if (selectedType != null && priceController.text.isNotEmpty) {
//                     final price = double.parse(priceController.text);
//                     print(price);
//                     print(selectedType);
//                     // context.read<GroomingTypesCubit>().addGroomingType(
//                     //       groomingType: selectedType!['type'],
//                     //       price: price,
//                     //     );
//                     cubit.addGroomingType(
//                         groomingType: selectedType!['type'], price: price);
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text('Add'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showEditTypeModal(BuildContext context, int index) {
//     final cubit = context.read<GroomingTypesCubit>();
//     final state = cubit.state as GroomingTypesLoaded;
//     final groomingType = state.types[index];
//     final TextEditingController priceController = TextEditingController(
//       text: groomingType['price'].toString(),
//     );

//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.all(16.0.w),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 groomingType['grooming_type'],
//                 style: Styles.styles14NormalBlack,
//               ),
//               TextField(
//                 controller: priceController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: 'Price'),
//               ),
//               SizedBox(height: 16.h),
//               ElevatedButton(
//                 onPressed: () {
//                   if (priceController.text.isNotEmpty) {
//                     final price = double.parse(priceController.text);
//                     final updatedType = {
//                       'grooming_type': groomingType['grooming_type'],
//                       'price': price,
//                     };
//                     context
//                         .read<GroomingTypesCubit>()
//                         .removeGroomingType(index);
//                     context.read<GroomingTypesCubit>().addGroomingType(
//                           groomingType: updatedType['grooming_type'],
//                           price: updatedType['price'],
//                         );
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text('Update'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

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
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {},
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
