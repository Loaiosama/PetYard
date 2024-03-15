import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'profile_centered_image.dart';

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

class ActivePetProfileSection extends StatelessWidget {
  const ActivePetProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        heightSizedBox(6),
        RichText(
          text: TextSpan(
            text: 'Active Pet Profiles ',
            style: Styles.styles18SemiBoldBlack.copyWith(letterSpacing: 1.5),
            children: [
              TextSpan(
                text: '2',
                style: Styles.styles22BoldGreen.copyWith(fontSize: 18.sp),
              ),
            ],
          ),
        ),
        heightSizedBox(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: List.generate(
                2,
                (index) => InkWell(
                  onTap: () {

                  },
                  child: const PetProfileCircle(),
                ),
              ),
            ),
            const PetProfileCircle(
              isAddNew: true,
            ),
          ],
        ),
        heightSizedBox(6),
        const Divider(),
      ],
    );
  }
}

class PetProfileCircle extends StatelessWidget {
  const PetProfileCircle({super.key, this.isAddNew = false});

  final bool isAddNew;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0.w),
      child: Column(
        children: [
          Container(
            width: 65.0.w,
            height: 65.0.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: !isAddNew
                  ? const DecorationImage(
                      image: AssetImage('assets/images/profile_dog.jpg'),
                      fit: BoxFit.cover,
                    )
                  : null,
              border: Border.all(
                color: kPrimaryGreen,
                width: 1.0.w,
              ),
            ),
            child: isAddNew
                ? Center(
                    child: IconButton(
                        onPressed: () {
                          GoRouter.of(context).push(Routes.kChooseType);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.grey,
                        )),
                  )
                : null,
          ),
          heightSizedBox(3),
          Text(
            !isAddNew ? 'Maxi' : 'Add new',
            style: !isAddNew
                ? Styles.styles22BoldGreen.copyWith(fontSize: 12.sp)
                : Styles.styles12RegularOpacityBlack,
          ),
        ],
      ),
    );
  }
}
