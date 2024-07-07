// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
// import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
// import 'package:petowner_frontend/core/utils/theming/colors.dart';
// import 'package:petowner_frontend/core/utils/theming/styles.dart';
// import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2.0,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//             onPressed: () {
//               GoRouter.of(context).pop();
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               size: 18.sp,
//               color: Colors.black,
//             )),
//         title: Text(
//           'Olivia Austin',
//           style: Styles.styles18SemiBoldBlack,
//         ),
//         centerTitle: true,
//       ),
//       body: const ChatScreenBody(),
//     );
//   }
// }

// class ChatScreenBody extends StatelessWidget {
//   const ChatScreenBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       children: [
//         Expanded(
//           flex: 5,
//           child: ChatContentColumn(),
//         ),
//         TypeMessageTextField(),
//       ],
//     );
//   }
// }

// class ChatContentColumn extends StatelessWidget {
//   const ChatContentColumn({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.0.h),
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10.0.r)),
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text('Session start'),
//             ),
//           ),
//           heightSizedBox(14),
//           Align(
//             alignment: Alignment.centerRight,
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.75,
//               child: Container(
//                 margin: EdgeInsets.only(bottom: 10.0.h),
//                 decoration: BoxDecoration(
//                   color: kPrimaryGreen,
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(16.0.r),
//                       bottomRight: Radius.circular(16.0.r),
//                       topLeft: Radius.circular(16.0.r)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Text(
//                     'Hello, Olivia!',
//                     style: Styles.styles14NormalBlack
//                         .copyWith(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.75,
//               child: Container(
//                 margin: EdgeInsets.only(bottom: 10.0.h),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(16.0.r),
//                       bottomRight: Radius.circular(16.0.r),
//                       topRight: Radius.circular(16.0.r)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Text(
//                     'Hello, Olivia!',
//                     style: Styles.styles14NormalBlack,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TypeMessageTextField extends StatelessWidget {
//   const TypeMessageTextField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Material(
//         color: Colors.white,
//         elevation: 2.0,
//         shadowColor: Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             children: [
//               CustomRegistrationTextField(
//                 width: MediaQuery.of(context).size.width * 0.75,
//                 controller: TextEditingController(),
//                 hintText: 'Type a message ...',
//                 suffixIcon: const Icon(
//                   FontAwesomeIcons.message,
//                   color: kPrimaryGreen,
//                 ),
//               ),
//               widthSizedBox(10),
//               Expanded(
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 0.07,
//                   decoration: const BoxDecoration(
//                     color: kPrimaryGreen,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.arrow_circle_right_rounded,
//                       size: 32.sp,
//                       color: const Color.fromRGBO(246, 241, 221, 1),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ChatScreen extends StatefulWidget {
//   final String senderId;
//   final String receiverId;
//   final String role;
//   final WebSocketChannel channel;

//   ChatScreen(
//       {required this.senderId, required this.receiverId, required this.role})
//       : channel = IOWebSocketChannel.connect('ws://localhost:8081');

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, String>> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     widget.channel.stream.listen((message) {
//       final parsedMessage = jsonDecode(message);
//       setState(() {
//         _messages.add(parsedMessage);
//       });
//     });
//     widget.channel.sink
//         .add(jsonEncode({'role': widget.role, 'senderId': widget.senderId}));
//   }

//   @override
//   void dispose() {
//     widget.channel.sink.close();
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
//       widget.channel.sink.add(jsonEncode(message));
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
//         title: Text(
//           'Chat',
//           style: TextStyle(
//               color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 final isMe = message['senderId'] == widget.senderId;
//                 return Align(
//                   alignment:
//                       isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin:
//                         EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                     padding: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.green : Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Text(message['text'] ?? ''),
//                   ),
//                 );
//               },
//             ),
//           ),
//           TypeMessageTextField(
//               controller: _controller, onSendMessage: _sendMessage),
//         ],
//       ),
//     );
//   }
// }

// class TypeMessageTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final VoidCallback onSendMessage;

//   TypeMessageTextField({required this.controller, required this.onSendMessage});

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
//                   suffixIcon: GestureDetector(
//                     onTap: onSendMessage,
//                     child: Icon(
//                       Icons.send,
//                       color: Colors.green,
//                       // onPressed: onSendMessage,
//                     ),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreenOld extends StatefulWidget {
  ChatScreenOld({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenOld> {
  final TextEditingController _controller = TextEditingController();
  final List _messages = [];
  final int senderId = 2; // Fixed senderId for testing
  final int receiverId = 1; // Fixed receiverId for testing
  final String role = 'petOwner'; // Fixed role for testing
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    channel = IOWebSocketChannel.connect('ws://192.168.56.1:8081');
    channel.stream.listen(
      (message) {
        print('Received message: $message');
        final parsedMessage = jsonDecode(message);
        setState(() {
          _messages.add(parsedMessage);
        });
      },
      onError: (error) {
        print('WebSocket error: $error');
        // Optionally handle error, maybe reconnect
      },
      onDone: () {
        print('WebSocket connection closed');
        // Optionally reconnect
      },
    );
    channel.sink.add(jsonEncode({'role': role, 'senderId': senderId}));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = {
        'senderId': senderId,
        'receiverId': receiverId,
        'text': _controller.text,
        'role': role,
      };
      print('Sending message: $message');
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
          ),
        ),
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['role'] == role;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.green : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(message['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          TypeMessageTextField(
            controller: _controller,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class TypeMessageTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;

  TypeMessageTextField({
    required this.controller,
    required this.onSendMessage,
  });

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
                    icon: Icon(
                      Icons.send,
                      color: Colors.green,
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
