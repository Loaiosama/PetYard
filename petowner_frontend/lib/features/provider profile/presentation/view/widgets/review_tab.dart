import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class ReviewsTabColumn extends StatelessWidget {
  const ReviewsTabColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSizedBox(12),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return const ReviewListItem();
            },
          ),
        ),
      ],
    );
  }
}

class ReviewListItem extends StatelessWidget {
  const ReviewListItem({super.key});
  final int review = 4;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.0.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/1.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              widthSizedBox(6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jane Cooper',
                    style: Styles.styles14w600,
                  ),
                  heightSizedBox(4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < review ? Colors.yellow : Colors.grey,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  heightSizedBox(4),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 60.0.w),
            child: Text(
              'As someone who lives in a remote area with limited access to healthcare, this telemedicine app has been a game changer for me. I can easily schedule virtual appointments with doctors and get the care I need without having to travel long distances.',
              style: Styles.styles12NormalHalfBlack,
            ),
          ),
        ],
      ),
    );
  }
}
