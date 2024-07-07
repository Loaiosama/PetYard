// chat_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petowner_frontend/features/chat/data/models/chat/chat.dart';
import 'package:petowner_frontend/features/chat/data/repo/chat_service.dart';

class ChatCubit extends Cubit<List<Chat>> {
  final ChatService _chatService;

  ChatCubit(this._chatService) : super([]);

  void fetchChats() async {
    try {
      final chats = await _chatService.getAllChats();
      // emit(chats);
      chats.fold(
        (l) => null,
        (r) => emit(r),
      );
    } catch (error) {
      emit([]);
      // print('Error fetching chats: $error');
    }
  }
}
