import 'package:equatable/equatable.dart';

class ChatDatum extends Equatable {
  final int? senderId;
  final int? receiverId;
  final String? role;
  final String? name;
  final String? image;
  final String? lastMessage;
  final DateTime? time;

  const ChatDatum({
    this.senderId,
    this.receiverId,
    this.role,
    this.name,
    this.image,
    this.lastMessage,
    this.time,
  });

  factory ChatDatum.fromJson(Map<String, dynamic> json) => ChatDatum(
        senderId: json['sender_id'] as int?,
        receiverId: json['receiver_id'] as int?,
        role: json['role'] as String?,
        name: json['name'] as String?,
        image: json['image'] as String?,
        lastMessage: json['last_message'] as String?,
        time: json['last_message_timestamp'] != null
            ? DateTime.parse(json['last_message_timestamp'] as String)
            : null, // Parse string to DateTime
      );

  Map<String, dynamic> toJson() => {
        'sender_id': senderId,
        'receiver_id': receiverId,
        'role': role,
        'name': name,
        'image': image,
        'last_message': lastMessage,
        'last_message_timestamp': time?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        senderId,
        receiverId,
        role,
        image,
        name,
        lastMessage,
        time,
      ];
}
