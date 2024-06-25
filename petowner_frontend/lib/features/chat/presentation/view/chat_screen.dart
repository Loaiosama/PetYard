import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
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
        title: Text(
          'Olivia Austin',
          style: Styles.styles18SemiBoldBlack,
        ),
        centerTitle: true,
      ),
      body: const ChatScreenBody(),
    );
  }
}

class ChatScreenBody extends StatelessWidget {
  const ChatScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          flex: 5,
          child: ChatContentColumn(),
        ),
        TypeMessageTextField(),
      ],
    );
  }
}

class ChatContentColumn extends StatelessWidget {
  const ChatContentColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.0.h),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0.r)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Session start'),
            ),
          ),
          heightSizedBox(14),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0.h),
                decoration: BoxDecoration(
                  color: kPrimaryGreen,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0.r),
                      bottomRight: Radius.circular(16.0.r),
                      topLeft: Radius.circular(16.0.r)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Hello, Olivia!',
                    style: Styles.styles14NormalBlack
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0.r),
                      bottomRight: Radius.circular(16.0.r),
                      topRight: Radius.circular(16.0.r)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Hello, Olivia!',
                    style: Styles.styles14NormalBlack,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TypeMessageTextField extends StatelessWidget {
  const TypeMessageTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        elevation: 2.0,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CustomRegistrationTextField(
                width: MediaQuery.of(context).size.width * 0.75,
                controller: TextEditingController(),
                hintText: 'Type a message ...',
                suffixIcon: const Icon(
                  FontAwesomeIcons.message,
                  color: kPrimaryGreen,
                ),
              ),
              widthSizedBox(10),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: const BoxDecoration(
                    color: kPrimaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_circle_right_rounded,
                      size: 32.sp,
                      color: const Color.fromRGBO(246, 241, 221, 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
