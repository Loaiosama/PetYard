import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/search_text_field.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

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
      body: const MessagesScreenBody(),
    );
  }
}

class MessagesScreenBody extends StatelessWidget {
  const MessagesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchTextField(
          onChanged: (p0) {},
        ),
        heightSizedBox(20),
        const Expanded(child: MessageItemListView()),
      ],
    );
  }
}

class MessageItemListView extends StatelessWidget {
  const MessageItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return const MessageItem();
      },
    );
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).push(Routes.kChatScreen);
      },
      borderRadius: BorderRadius.circular(4.0.r),
      splashColor: kPrimaryGreen.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80.h,
              width: 70.w,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/1.png',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            widthSizedBox(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olivia Austin',
                  style: Styles.styles16BoldBlack.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                heightSizedBox(4),
                Text(
                  'Pet Sitter || Pet Walker',
                  style: Styles.styles12NormalHalfBlack,
                ),
                heightSizedBox(2),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'Fine, I\'ll do a check. Does the patient have a history of certain diseases?',
                    style: Styles.styles12NormalHalfBlack,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            // widthSizedBox(10),
            const Spacer(),
            Column(
              children: [
                Text(
                  '10:11pm',
                  style: Styles.styles12RegularOpacityBlack,
                ),
                heightSizedBox(20),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryGreen,
                    borderRadius: BorderRadius.circular(6.0.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 4.0.h, horizontal: 6.0.w),
                    child: const Text(
                      '2',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
