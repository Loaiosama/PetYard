// chat_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petprovider_frontend/features/chat/data/models/chatmodel/chat.dart';
import 'package:petprovider_frontend/features/chat/data/repo/chat_service.dart';

class ChatCubit extends Cubit<List<Chat>> {
  final ChatService _chatService;

  ChatCubit(this._chatService) : super([]);

  void fetchChats() async {
    try {
      final chats = await _chatService.getAllChats();
      print('Fetched Chats: $chats'); // Debugging line

      chats.fold(
        (l) => print('Error: $l'), // Debugging line
        (r) => emit(r),
      );
    } catch (error) {
      print('Exception: $error'); // Debugging line
      emit([]);
    }
  }
}
