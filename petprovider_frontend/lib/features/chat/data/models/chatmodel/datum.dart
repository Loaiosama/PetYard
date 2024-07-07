import 'package:equatable/equatable.dart';

class ChatDatum extends Equatable {
  final int? senderId;
  final int? receiverId;
  final String? role;

  const ChatDatum({this.senderId, this.receiverId, this.role});

  factory ChatDatum.fromJson(Map<String, dynamic> json) => ChatDatum(
        senderId: json['sender_id'] as int?,
        receiverId: json['receiver_id'] as int?,
        role: json['role'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'sender_id': senderId,
        'receiver_id': receiverId,
        'role': role,
      };

  @override
  List<Object?> get props => [senderId, receiverId, role];
}
