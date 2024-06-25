import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/search_text_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: Styles.styles18SemiBoldBlack,
        ),
        centerTitle: true,
        actions: [
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(right: 10.0.w),
            decoration: BoxDecoration(
              // shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
                style: BorderStyle.solid,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(10.0.r),
            ),
            child: Center(
              child: IconButton(
                onPressed: () {},
                icon: Tooltip(
                  message: 'Create new message',
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
          )
        ],
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
        SearchTextField(),
      ],
    );
  }
}
