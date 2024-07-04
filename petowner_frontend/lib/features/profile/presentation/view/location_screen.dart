import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class ProfileLocationScreen extends StatelessWidget {
  const ProfileLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Address',
          style: Styles.styles18RegularBlack,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Add',
              style: Styles.styles16w600
                  .copyWith(color: kPrimaryGreen, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
      body: const LocationScreenBody(),
    );
  }
}

class LocationScreenBody extends StatelessWidget {
  const LocationScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [],
    );
  }
}
