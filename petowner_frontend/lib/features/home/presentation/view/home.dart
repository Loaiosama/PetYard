import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/features/profile/presentation/view/profile_screen.dart';
import 'widgets/home_screen_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List screens = [
    const HomeScreenBody(),
    const Center(
      child: Text('Requests'),
    ),
    Container(),
    const Center(
      child: Text('Community'),
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        backgroundColor: Colors.white,
        elevation: 2.0,
        // or transparent
        // indicatorColor: kPrimaryGreen.withOpacity(0.4),
        indicatorColor: Colors.transparent,
        selectedIndex: currentIndex,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        // labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(
              FluentIcons.home_28_regular,
              color: Colors.black.withOpacity(0.5),
            ),
            label: 'Home',
            selectedIcon: const Icon(
              FluentIcons.home_28_filled,
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
          Padding(
            padding: EdgeInsets.only(bottom: 30.0.w),
            child: NavigationDestination(
              label: 'Inbox',
              icon: Container(
                decoration: const BoxDecoration(
                  color: kPrimaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: const EdgeInsets.all(13.0),
                  child: const Icon(
                    Icons.sports_gymnastics_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
