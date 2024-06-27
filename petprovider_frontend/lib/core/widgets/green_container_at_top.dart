import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/theming/colors.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';

class GreenContainerAtTop extends StatelessWidget {
  const GreenContainerAtTop(
      {super.key,
      this.title = '',
      this.subTitle = '',
      this.subTitleStyle,
      this.titleStyle,
      this.isBack = false});
  final String? title;
  final String? subTitle;
  final TextStyle? subTitleStyle;
  final TextStyle? titleStyle;
  final bool? isBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      color: kPrimaryGreen,
      child: SafeArea(
        child: Padding(
          padding: isBack!
              ? EdgeInsets.only(left: 16.w, top: 14.w)
              : EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isBack!
                  ? InkWell(
                      onTap: () {
                        GoRouter.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 18.sp,
                        color: Colors.white,
                      ))
                  : const SizedBox(),
              isBack!
                  ? const SizedBox()
                  : Text(
                      title!,
                      style: titleStyle ?? Styles.styles18AppBarWhite,
                    ),
              isBack! ? heightSizedBox(20) : heightSizedBox(10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  subTitle!,
                  style: subTitleStyle ??
                      Styles.styles12NormalHalfBlack
                          .copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
