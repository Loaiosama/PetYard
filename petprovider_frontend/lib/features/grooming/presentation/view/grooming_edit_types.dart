import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';

class EditGroomingTypesTab extends StatelessWidget {
  final List<dynamic> types;

  const EditGroomingTypesTab({super.key, required this.types});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Add Grooming Types', style: Styles.styles16BoldBlack),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // print(widget.types);
              // Add your logic to add new grooming type here
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: ListView.builder(
          itemCount: types.length,
          itemBuilder: (context, index) {
            final groomingType = types[index];
            return Card(
              color: Colors.grey.shade300,
              margin: EdgeInsets.symmetric(vertical: 8.0.h),
              child: ListTile(
                title: Text(groomingType["grooming_type"],
                    style: Styles.styles14NormalBlack),
                // subtitle: Text('\$${groomingType['price']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.penToSquare,
                        color: kPrimaryGreen,
                      ),
                      onPressed: () {
                        // Add your logic to edit the grooming type here
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
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
