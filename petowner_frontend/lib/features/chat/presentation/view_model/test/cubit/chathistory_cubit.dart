import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/features/chat/data/models/individual_chats/individual_chats.dart';
import 'package:petowner_frontend/features/chat/data/repo/chat_service.dart';

part 'chathistory_state.dart';

class ChathistoryCubit extends Cubit<ChathistoryState> {
  ChathistoryCubit(this.chatService) : super(ChathistoryInitial());
  final ChatService chatService;

  Future<void> getChatHistory(int receiverId) async {
    emit(ChatLoading());
    Either<Failure, List<IndividualChats>> result =
        await chatService.getChatHistory(receiverId);
    result.fold(
      (failure) => emit(ChatError(failure.errorMessage)),
      (chats) => emit(ChatLoaded(chats)),
    );
  }
}
