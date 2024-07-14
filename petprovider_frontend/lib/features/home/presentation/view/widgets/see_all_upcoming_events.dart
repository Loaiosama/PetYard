import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/features/home/presentation/view/widgets/home_screen_body.dart';

import '../../../data/models/upcoming_events/upcoming_datum.dart';

class SeeAllUpcomingEvents extends StatelessWidget {
  const SeeAllUpcomingEvents({super.key, required this.data});
  final List<UpcomingDatum> data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text(
          'Upcoming Events',
          style: Styles.styles18AppBarBlack,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 30.h),
        child: Expanded(
            child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return UpcomingEventsListItem(
              endDate: data[index].endTime ?? DateTime.now(),
              image: data[index].petImage ?? '',
              serviceName: data[index].serviceType ?? "",
              startDate: data[index].startTime ?? DateTime.now(),
              finalPrice: data[index].finalPrice ?? 0.0,
              reserveId: data[index].reserveId ?? -1,
            );
          },
        )),
      ),
    );
  }
}
