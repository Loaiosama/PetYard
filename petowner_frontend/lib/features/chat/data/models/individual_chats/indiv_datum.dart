import 'package:equatable/equatable.dart';

class IndividualDatum extends Equatable {
  final int? senderId;
  final int? receiverId;
  final String? message; // Ensure message is a String
  final DateTime? timestamp;
  final String? role;

  const IndividualDatum({
    this.senderId,
    this.receiverId,
    this.message,
    this.timestamp,
    this.role,
  });

  factory IndividualDatum.fromJson(Map<String, dynamic> json) =>
      IndividualDatum(
        senderId: json['sender_id'] as int?,
        receiverId: json['receiver_id'] as int?,
        message:
            json['message'] as String?, // Ensure message is parsed as a String
        timestamp: json['timestamp'] == null
            ? null
            : DateTime.parse(json['timestamp'] as String),
        role: json['role'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message': message,
        'timestamp': timestamp?.toIso8601String(),
        'role': role,
      };

  @override
  List<Object?> get props => [senderId, receiverId, message, timestamp, role];
}
