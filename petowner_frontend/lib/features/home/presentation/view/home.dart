import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/features/Requests/representation/view/requests.dart';
import 'package:petowner_frontend/features/applications/representation/view/applications.dart';
import 'package:petowner_frontend/features/appointments%20history/presentation/view/appointments_screen.dart';
import 'package:petowner_frontend/features/chat/presentation/view/messages_screen.dart';
import 'package:petowner_frontend/features/profile/presentation/view/profile_screen.dart';
import 'widgets/home_screen_body.dart';

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
    const Applications(),
    // const MessagesScreen(),
    const MessagesScreen(),
    const AppointmentsScreen(),
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
              Iconsax.clipboard_text4,
              color: Colors.black.withOpacity(0.5),
            ),
            selectedIcon: const Icon(
              Iconsax.clipboard_text5,
              color: kPrimaryGreen,
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
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.message,
                      // Iconsax.messages4,
                      // FluentIcons.chat_20_regular,
                      // size: 26.sp,
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
