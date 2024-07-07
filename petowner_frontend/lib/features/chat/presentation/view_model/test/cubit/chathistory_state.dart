part of 'chathistory_cubit.dart';

sealed class ChathistoryState extends Equatable {
  const ChathistoryState();

  @override
  List<Object> get props => [];
}

final class ChathistoryInitial extends ChathistoryState {}

class ChatLoading extends ChathistoryState {}

class ChatLoaded extends ChathistoryState {
  final List<IndividualChats> chats;

  const ChatLoaded(this.chats);
}

class ChatError extends ChathistoryState {
  final String errorMessage;

  const ChatError(this.errorMessage);
}
