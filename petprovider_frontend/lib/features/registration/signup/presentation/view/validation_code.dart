import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';
import 'package:petprovider_frontend/core/widgets/petyard_text_button.dart';
import 'package:petprovider_frontend/features/registration/signup/presentation/view/widgets/first_section.dart';

class ValdiationCodeScreen extends StatelessWidget {
  const ValdiationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          right: 16.0.w,
          left: 18.0.w,
          top: 20.0.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FirstSection(
              title: 'Validation Code',
              subTitle: 'We have sent a validation code to your email.',
            ),
            heightSizedBox(10),
            const OtpForm(),
            const Spacer(),
            PetYardTextButton(
              height: 50.h,
              onPressed: () {},
              text: 'Submit',
              style: Styles.styles16BoldWhite,
            )
          ],
        ),
      ),
    );
  }
}

class OtpForm extends StatelessWidget {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          6,
          (index) => SizedBox(
            height: 60.h,
            width: 44.w,
            child: TextFormField(
              onSaved: (newValue) {},
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0.r))),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
            ),
          ),
        ),
      ),
    );
  }
}
