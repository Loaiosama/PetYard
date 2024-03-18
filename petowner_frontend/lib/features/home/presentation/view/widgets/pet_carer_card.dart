import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class PetCarerCardWidget extends StatelessWidget {
  const PetCarerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {},
        splashColor: kPrimaryGreen.withOpacity(0.3),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16.sp,
                    ),
                    widthSizedBox(5),
                    Text('4.8 (4,279 reviews)',
                        style: Styles.styles12RegularOpacityBlack),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
