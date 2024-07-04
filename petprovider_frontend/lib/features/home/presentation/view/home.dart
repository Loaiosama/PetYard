import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/features/handle%20requests/presentation/view/handel_requests.dart';
import 'package:petprovider_frontend/features/home/presentation/view/widgets/home_screen_body.dart';
import 'package:petprovider_frontend/features/home/presentation/view/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int currentIndex = 0;

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  List screens = [
    const HomeScreenBody(),
    Container(),
    Jobs(),
    Container(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //to discuss
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   mini: true,
      // ),
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        backgroundColor: Colors.white,
        elevation: 2.0,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        // height: 80.h,
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
              Iconsax.home_2,
              color: Colors.black.withOpacity(0.5),
            ),
            label: 'Home',
            selectedIcon: const Icon(
              Iconsax.home_25,
              color: kPrimaryGreen,
            ),
          ),
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.message,
              color: Colors.black.withOpacity(0.5),
            ),
            selectedIcon: const Icon(
              FontAwesomeIcons.solidMessage,
              color: kPrimaryGreen,
            ),
            label: 'Inbox',
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 28.0.w),
            child: NavigationDestination(
              label: 'Jobs',
              icon: Container(
                decoration: const BoxDecoration(
                  color: kPrimaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: const EdgeInsets.all(13.0),
                  child: const Center(
                    child: Icon(
                      // Iconsax.clipboard_text4,
                      FontAwesomeIcons.briefcase,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.calendar,
              color: Colors.black.withOpacity(0.5),
            ),
            selectedIcon: const Icon(
              FontAwesomeIcons.solidCalendar,
              color: kPrimaryGreen,
            ),
            label: 'Appointment',
          ),
          NavigationDestination(
            icon: Icon(
              Iconsax.profile_circle,
              color: Colors.black.withOpacity(0.5),
            ),
            selectedIcon: const Icon(
              Iconsax.profile_circle5,
              color: kPrimaryGreen,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
