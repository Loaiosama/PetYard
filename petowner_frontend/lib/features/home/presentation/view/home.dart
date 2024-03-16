import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/features/profile/presentaiton/view/profile_screen.dart';

import 'widgets/home_screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.search),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // body: const HomeScreenBody(),
      body: const ProfileScreen(),
      // bottomNavigationBar: BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      //   notchMargin: 8,
      //   clipBehavior: Clip.antiAlias,
      //   child: Container(
      //     height: 60,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Row(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               MaterialButton(
      //                 onPressed: () {},
      //                 minWidth: 40,
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [Icon(Icons.account_circle), Text('data')],
      //                 ),
      //               ),
      //             ]),
      //         Row(crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               MaterialButton(
      //                 onPressed: () {},
      //                 minWidth: 40,
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [Icon(Icons.account_circle), Text('data')],
      //                 ),
      //               ),
      //             ]), Row(crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               MaterialButton(
      //                 onPressed: () {},
      //                 minWidth: 40,
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [Icon(Icons.account_circle), Text('data')],
      //                 ),
      //               ),
      //             ]), Row(crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               MaterialButton(
      //                 onPressed: () {},
      //                 minWidth: 40,
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [Icon(Icons.account_circle), Text('data')],
      //                 ),
      //               ),
      //             ]),
      //       ],
      //     ),
      //   ),
      // ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        // or transparent
        indicatorColor: kPrimaryGreen.withOpacity(0.4),
        selectedIndex: 0,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        // labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(
              FluentIcons.home_28_filled,
              color: Colors.black.withOpacity(0.5),
            ),
            label: 'Home',
            selectedIcon: const Icon(
              FluentIcons.home_28_regular,
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
