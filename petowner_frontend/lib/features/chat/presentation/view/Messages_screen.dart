import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/features/chat/data/models/chat/chat.dart';
import 'package:petowner_frontend/features/chat/data/models/chat/datum.dart';
import 'package:petowner_frontend/features/chat/presentation/view_model/chat/cubit/chat_cubit.dart';
import '../../data/repo/chat_service.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: const MessagesScreenBody(),
    );
  }
}

class MessagesScreenBody extends StatelessWidget {
  const MessagesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatCubit(ChatService(apiService: ApiService(dio: Dio())))
            ..fetchChats(),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          const Expanded(child: MessageItemListView()),
        ],
      ),
    );
  }
}

class MessageItemListView extends StatelessWidget {
  const MessageItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, List<Chat>>(
      builder: (context, chats) {
        chats.sort((chat1, chat2) =>
            chat2.data!.first.time!.compareTo(chat1.data!.first.time!));
        if (chats.isEmpty) {
          return const Center(child: Text('No chats available'));
        }

        return ListView.separated(
          itemCount: chats.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final chat = chats[index]
                .data
                ?.first; // Adjusting to get the first chat data
            if (chat == null) {
              return const SizedBox(); // Return an empty widget if chat is null
            }
            return MessageItem(chat: chat);
          },
        );
      },
    );
  }
}

class MessageItem extends StatelessWidget {
  final ChatDatum chat;

  const MessageItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // print(chat.role);
        GoRouter.of(context).push(Routes.kChatScreen, extra: {
          "senderId": chat.senderId,
          "receiverId": chat.receiverId,
          "role": 'petOwner'
          // "senderId": chat.role == 'provider' ? chat.senderId : chat.receiverId,
          // "receiverId":
          //     chat.role == 'provider' ? chat.receiverId : chat.senderId,
          // "role": chat.role
        });
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
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/profile_pictures/${chat.image ?? 'default.png'}'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.name ?? 'no name',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    // 'Chat between ${chat.senderId} and ${chat.receiverId}',
                    '${chat.lastMessage}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                ),
                SizedBox(height: 2.h),
                // Last message preview, to be fetched and shown here
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  DateFormat('HH:mm').format(chat
                      .time!), // This should be the timestamp of the last message
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
