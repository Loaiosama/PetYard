import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:petprovider_frontend/features/chat/data/models/chatmodel/chat.dart';
import 'package:petprovider_frontend/features/chat/data/models/chatmodel/datum.dart';
import 'package:petprovider_frontend/features/chat/data/models/individual_chats/indiv_datum.dart';
import 'package:petprovider_frontend/features/chat/data/models/individual_chats/individual_chats.dart';
import 'package:petprovider_frontend/core/errors/failure.dart';
import 'package:petprovider_frontend/core/utils/networking/api_service.dart';

class ChatService {
  final ApiService apiService;

  ChatService({required this.apiService});

  Future<Either<Failure, List<Chat>>> getAllChats() async {
    List<Chat> allChats = [];
    try {
      await apiService.setAuthorizationHeader();
      var response = await apiService.get(endpoint: 'Provider/getAllChats');
      // print('API Response: $response'); // Debugging line

      if (response['Status'] == 'Success') {
        for (var item in response['data']) {
          // print('Parsing item: $item'); // Debugging line
          var datum = ChatDatum.fromJson(item);
          // print('object');
          var chat = Chat(
            data: [datum],
            status: response['Status'],
          );
          allChats.add(chat);
        }
        // print('Parsed Chats: $allChats'); // Debugging line
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
      int senderId, int receiverId) async {
    List<IndividualChats> chats = [];

    try {
      await apiService.setAuthorizationHeader();
      var response = await apiService.get(
          endpoint: 'Provider/getChatHistory/$senderId/$receiverId');
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
