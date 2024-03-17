import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/profile/data/model/options_card.dart';
import 'active_pet_profile_section.dart';
import 'profile_centered_image.dart';
import 'profile_options_card.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.71,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.0.w, right: 20.0.w, top: 72.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Olivia Austin',
                          style: Styles.styles20SemiBoldBlack,
                        ),
                        heightSizedBox(2),
                        Text(
                          'olivia@example.com',
                          style: Styles.styles12RegularOpacityBlack,
                        ),
                        heightSizedBox(6),
                        const ActivePetProfileSection(),
                        heightSizedBox(16),
                        Column(
                          children: List.generate(
                            3,
                            (index) => Column(
                              children: [
                                ProfileOptionsCard(
                                  cardColor: cardColors[index],
                                  iconColor: iconColors[index],
                                  label: labels[index],
                                  icon: icons[index],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const ProfileScreenCenteredImage(),
      ],
    );
  }
}


