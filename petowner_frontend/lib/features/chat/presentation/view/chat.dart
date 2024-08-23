import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/features/chat/presentation/view_model/test/cubit/chathistory_cubit.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OwnerChatScreen extends StatefulWidget {
  final int senderId;
  final int receiverId;
  final String role;

  const OwnerChatScreen({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.role,
  });

  @override
  ProviderChatScreenState createState() => ProviderChatScreenState();
}

class ProviderChatScreenState extends State<OwnerChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List _messages = [];
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
    context.read<ChathistoryCubit>().getChatHistory(widget.receiverId);
  }

  void _connectWebSocket() {
    channel = IOWebSocketChannel.connect('ws://192.168.56.1:8083');
    channel.stream.listen(
      (message) {
        final parsedMessage = jsonDecode(message);
        if (parsedMessage['text'].isNotEmpty) {
          setState(() {
            _messages.add(parsedMessage);
          });
        }
        // setState(() {
        //   _messages.add(parsedMessage);
        // });
      },
      onError: (error) {
        // print('WebSocket error: $error');
      },
      onDone: () {
        // print('WebSocket connection closed');
      },
    );
    channel.sink.add(jsonEncode({
      'role': widget.role,
      'senderId': widget.senderId,
      'receiverId': widget.receiverId,
      'text': '',
    }));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = {
        'senderId': widget.senderId,
        'receiverId': widget.receiverId,
        'text': _controller.text,
        'role': widget.role,
      };
      channel.sink.add(jsonEncode(message));
      setState(() {
        _messages.add(message);
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
              color: Colors.black,
            )),
        title: const Text(
          'Chat',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ChathistoryCubit, ChathistoryState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            return Column(
              children: [
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                    itemCount: state.chats.length + _messages.length,
                    itemBuilder: (context, index) {
                      if (index < state.chats.length) {
                        final message = state.chats[index];
                        final isMe = message.data?[0].role == widget.role;
                        // print('message ${message.data?[0].role}');
                        return message.data?[0].message == ''
                            ? const SizedBox()
                            : Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? kPrimaryGreen
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    message.data?[0].message ?? '',
                                    style: TextStyle(
                                        color:
                                            isMe ? Colors.white : Colors.black),
                                  ),
                                ),
                              );
                      } else {
                        final message = _messages[index - state.chats.length];
                        final isMe = message['role'] == widget.role;

                        return Align(
                          alignment: (isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color:
                                  isMe ? kPrimaryGreen : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              message['text'],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                TypeMessageTextField(
                    controller: _controller, onSendMessage: _sendMessage),
              ],
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: Text('No messages yet.'));
          }
        },
      ),
    );
  }
}

class TypeMessageTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;

  const TypeMessageTextField(
      {super.key, required this.controller, required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2.0,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Type a message ...',
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: kPrimaryGreen,
                    ),
                    onPressed: onSendMessage,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:petowner_frontend/core/utils/theming/colors.dart';
// import 'package:petowner_frontend/features/chat/presentation/view_model/test/cubit/chathistory_cubit.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class OwnerChatScreen extends StatefulWidget {
//   final int senderId;
//   final int receiverId;
//   final String role;

//   const OwnerChatScreen({
//     super.key,
//     required this.senderId,
//     required this.receiverId,
//     required this.role,
//   });

//   @override
//   ProviderChatScreenState createState() => ProviderChatScreenState();
// }

// class ProviderChatScreenState extends State<OwnerChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List _messages = [];
//   late WebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();
//     _connectWebSocket();
//     context.read<ChathistoryCubit>().getChatHistory(widget.receiverId);
//   }

//   void _connectWebSocket() {
//     channel = IOWebSocketChannel.connect('ws://192.168.56.1:8083');
//     channel.stream.listen(
//       (message) {
//         final parsedMessage = jsonDecode(message);
//         if (parsedMessage['text'].isNotEmpty) {
//           setState(() {
//             _messages.add(parsedMessage);
//           });
//         }
//       },
//       onError: (error) {
//         // print('WebSocket error: $error');
//       },
//       onDone: () {
//         // print('WebSocket connection closed');
//       },
//     );
//     channel.sink.add(jsonEncode({
//       'role': widget.role,
//       'senderId': widget.senderId,
//       'receiverId': widget.receiverId,
//       'text': '',
//     }));
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }

//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       final message = {
//         'senderId': widget.senderId,
//         'receiverId': widget.receiverId,
//         'text': _controller.text,
//         'role': widget.role,
//       };
//       channel.sink.add(jsonEncode(message));
//       setState(() {
//         _messages.add(message);
//       });
//       _controller.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2.0,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               size: 18.sp,
//               color: Colors.black,
//             )),
//         title: const Text(
//           'Chat',
//           style: TextStyle(
//               color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<ChathistoryCubit, ChathistoryState>(
//         builder: (context, state) {
//           if (state is ChatLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is ChatLoaded) {
//             return Column(
//               children: [
//                 Expanded(
//                   flex: 5,
//                   child: ListView.builder(
//                     itemCount: state.chats.length + _messages.length,
//                     itemBuilder: (context, index) {
//                       if (index < state.chats.length) {
//                         final message = state.chats[index];
//                         final isMe = message.data?[0].role == widget.role;
//                         // print('message ${message.data?[0].role}');
//                         return message.data?[0].message?.isEmpty ?? true
//                             ? const SizedBox()
//                             : Align(
//                                 alignment: isMe
//                                     ? Alignment.centerRight
//                                     : Alignment.centerLeft,
//                                 child: Container(
//                                   margin: const EdgeInsets.symmetric(
//                                       vertical: 10.0, horizontal: 20.0),
//                                   padding: const EdgeInsets.all(10.0),
//                                   decoration: BoxDecoration(
//                                     color: isMe
//                                         ? kPrimaryGreen
//                                         : Colors.grey.shade200,
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Text(
//                                     message.data?[0].message ?? '',
//                                     style: TextStyle(
//                                         color:
//                                             isMe ? Colors.white : Colors.black),
//                                   ),
//                                 ),
//                               );
//                       } else {
//                         final message = _messages[index - state.chats.length];
//                         final isMe = message['role'] == widget.role;

//                         return message['text'].isEmpty
//                             ? const SizedBox()
//                             : Align(
//                                 alignment: (isMe
//                                     ? Alignment.centerRight
//                                     : Alignment.centerLeft),
//                                 child: Container(
//                                   margin: const EdgeInsets.symmetric(
//                                       vertical: 10.0, horizontal: 20.0),
//                                   padding: const EdgeInsets.all(10.0),
//                                   decoration: BoxDecoration(
//                                     color: isMe
//                                         ? kPrimaryGreen
//                                         : Colors.grey.shade200,
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Text(
//                                     message['text'],
//                                   ),
//                                 ),
//                               );
//                       }
//                     },
//                   ),
//                 ),
//                 TypeMessageTextField(
//                     controller: _controller, onSendMessage: _sendMessage),
//               ],
//             );
//           } else if (state is ChatError) {
//             return Center(child: Text(state.errorMessage));
//           } else {
//             return const Center(child: Text('No messages yet.'));
//           }
//         },
//       ),
//     );
//   }
// }

// class TypeMessageTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final VoidCallback onSendMessage;

//   const TypeMessageTextField(
//       {super.key, required this.controller, required this.onSendMessage});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       elevation: 2.0,
//       shadowColor: Colors.black,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                   hintText: 'Type a message ...',
//                   suffixIcon: IconButton(
//                     icon: const Icon(
//                       Icons.send,
//                       color: kPrimaryGreen,
//                     ),
//                     onPressed: onSendMessage,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
