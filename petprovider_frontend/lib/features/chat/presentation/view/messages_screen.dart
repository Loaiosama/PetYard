import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petprovider_frontend/features/chat/data/models/chatmodel/chat.dart';
import 'package:petprovider_frontend/features/chat/data/models/chatmodel/datum.dart';
import 'package:petprovider_frontend/features/chat/presentation/view_model/chat/cubit/chat_cubit.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';
import 'package:petprovider_frontend/core/utils/routing/routes.dart';
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
        actions: [
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(right: 10.0.w),
            decoration: BoxDecoration(
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
    return BlocProvider(
      create: (context) =>
          ChatCubit(ChatService(apiService: ApiService(dio: Dio())))
            ..fetchChats(), // Replace '2' with the actual providerId
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
        GoRouter.of(context).push(Routes.kChatScreen, extra: {
          "senderId": chat.senderId,
          "receiverId": chat.receiverId,
          // "role": chat.role
          "role": 'serviceProvider'
          // "senderId": chat.role == 'provider' ? chat.senderId : chat.receiverId,
          // "receiverId":
          //     chat.role == 'provider' ? chat.receiverId : chat.senderId,
          // "role": chat.role
        });
      },
      borderRadius: BorderRadius.circular(4.0.r),
      splashColor: Colors.green.withOpacity(0.2),
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
                  image: AssetImage('assets/images/1.png'),
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
                  chat.role == 'serviceProvider' ? 'Service Provider' : 'Owner',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Chat between ${chat.senderId} and ${chat.receiverId}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),
                SizedBox(height: 2.h),
                // Last message preview, to be fetched and shown here
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  '10:11pm', // This should be the timestamp of the last message
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                ),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6.0.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 4.0.h, horizontal: 6.0.w),
                    child: const Text(
                      '2', // This should be the number of unread messages
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
