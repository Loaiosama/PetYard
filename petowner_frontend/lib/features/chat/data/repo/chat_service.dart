import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petowner_frontend/core/errors/failure.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/features/chat/data/models/chat/chat.dart';
import 'package:petowner_frontend/features/chat/data/models/chat/datum.dart';
import 'package:petowner_frontend/features/chat/data/models/individual_chats/indiv_datum.dart';
import 'package:petowner_frontend/features/chat/data/models/individual_chats/individual_chats.dart';

class ChatService {
  final ApiService apiService;

  ChatService({required this.apiService});

  Future<Either<Failure, List<Chat>>> getAllChats() async {
    List<Chat> allChats = [];
    try {
      await apiService.setAuthorizationHeader();
      var response = await apiService.get(endpoint: 'PetOwner/getAllChats');
      print(response);
      if (response['Status'] == 'Success') {
        for (var item in response['data']) {
          // print(item);
          var datum = ChatDatum.fromJson(item);
          var chat = Chat(
            data: [datum],
            status: response['Status'],
          );
          // print(chat);
          allChats.add(chat);
        }
        print(allChats);
        return right(allChats);
      } else {
        return left(
            ServerFailure('Failed to load chats: ${response['Message']}'));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<IndividualChats>>> getChatHistory(
      int receiverId) async {
    List<IndividualChats> chats = [];

    try {
      await apiService.setAuthorizationHeader();
      var response =
          await apiService.get(endpoint: 'PetOwner/getChatHistory/$receiverId');
      print(response['data']);
      if (response['Status'] == 'Success') {
        for (var item in response['data']) {
          var datum = IndividualDatum.fromJson(item);
          var chat = IndividualChats(
            data: [datum],
            status: response['Status'],
          );
          chats.add(chat);
        }
        return right(chats);
      } else {
        return left(ServerFailure(
            'Failed to load chat history: ${response['Message']}'));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
