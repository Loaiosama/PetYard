import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/fonts_helper.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/home/data/model/service_map.dart';

import 'see_all.dart';

class DiscoverServiceWidget extends StatelessWidget {
  const DiscoverServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeeAllRow(
          title: 'Discover Services',
          onPressed: () {},
        ),
        heightSizedBox(10),
        SizedBox(
          height: 83.h,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: homeServicesMap.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      splashColor: kPrimaryGreen.withOpacity(0.4),
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(244, 248, 255, 1),
                        radius: 30.r,
                        child: SvgPicture.asset(
                          homeServicesMap[index]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 50.h,
                    //   width: 50.w,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: const Color.fromRGBO(244, 248, 255, 1),
                    //   ),
                    //   child: SvgPicture.asset(
                    //     homeServicesMap[index]['image'],
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    Text(
                      homeServicesMap[index]['title'],
                      style: Styles.styles12RegularOpacityBlack.copyWith(
                          color: Colors.black, fontWeight: FontsHelper.regular),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
