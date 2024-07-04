import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/applications/representation/view/widgets/service_applications.dart';

class Applications extends StatelessWidget {
  const Applications({Key? key});

  @override
  Widget build(BuildContext context) {
    List<String> Services = [
      "Sitting",
      "Walking",
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Applications",
          style: Styles.styles16w600,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TabBar(
                    tabAlignment: TabAlignment.center,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (value) {},
                    dividerHeight: 0,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: kPrimaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tabs: Services.map((service) => Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 20.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                service,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )).toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ServiceApplications(service: "Sitting"),
                      ServiceApplications(service: "Walking"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
