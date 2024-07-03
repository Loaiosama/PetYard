import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class PetCarerCardWidget extends StatelessWidget {
  const PetCarerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(
                  'assets/images/1.png',
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          widthSizedBox(18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Olivia Wattson',
                style: Styles.styles18BoldBlack,
              ),
              heightSizedBox(6),
              Text(
                'Pet Sitter | Pet Walker',
                style: Styles.styles12RegularOpacityBlack,
              ),
              heightSizedBox(6),
              const RatingRowWidget(),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30.0.r),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Tooltip(
                message: 'Book Service',
                child: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black.withOpacity(0.5),
                  size: 22.0.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingRowWidget extends StatelessWidget {
  const RatingRowWidget({
    super.key,
    this.rating,
    this.count,
  });
  final double? rating;
  final String? count;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 16.sp,
        ),
        widthSizedBox(5),
        Text('${rating?.toStringAsFixed(2) ?? '4.8'} (${count ?? '4,279'})',
            style: Styles.styles12RegularOpacityBlack),
      ],
    );
  }
}
// 4.8 (4,279 reviews)