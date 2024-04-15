import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

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
            width: 60.0.w,
            height: 60.0.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: !isAddNew
                  ? const DecorationImage(
                      image: AssetImage('assets/images/profile_dog.jpg'),
                      fit: BoxFit.cover,
                    )
                  : null,
              border: !isAddNew
                  ? Border.all(
                      color: kPrimaryGreen,
                      width: 1.0.w,
                    )
                  : null,
            ),
            child: isAddNew
                ? Center(
                    child: IconButton(
                        onPressed: () {
                          GoRouter.of(context).push(Routes.kChooseType);
                        },
                        icon: Tooltip(
                          message: "Add new Pet",
                          child: Icon(
                            FontAwesomeIcons.circlePlus,
                            color: kPrimaryGreen.withOpacity(0.6),
                            size: 30.sp,
                          ),
                        )),
                  )
                : null,
          ),
          heightSizedBox(3),
          Text(
            !isAddNew ? 'Maxi' : 'Add Pet',
            style: !isAddNew
                ? Styles.styles22BoldGreen.copyWith(fontSize: 12.sp)
                : Styles.styles12RegularOpacityBlack,
          ),
        ],
      ),
    );
  }
}
