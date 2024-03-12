import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';

import 'widgets/home_screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeScreenBody(),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        indicatorColor: Colors.transparent,
        selectedIndex: 0,
        // shadowColor: Colors.black,
        // surfaceTintColor: Colors.white,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_max_outlined,
              color: Colors.black.withOpacity(0.5),
            ),
            label: 'Home',
            selectedIcon: const Icon(
              Icons.home_max_outlined,
              color: kPrimaryGreen,
            ),
          ),
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.fileLines,
              color: Colors.black.withOpacity(0.5),
            ),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.squarePlus,
              color: Colors.black.withOpacity(0.5),
            ),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.user,
              color: Colors.black.withOpacity(0.5),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
