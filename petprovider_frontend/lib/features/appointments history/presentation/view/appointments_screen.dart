import 'package:flutter/material.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';

import 'widgets/appointment_screen_body.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'My Appointments',
          style: Styles.styles18SemiBoldBlack,
        ),
        centerTitle: true,
      ),
      body: const AppointmentsScreenBody(),
    );
  }
}
