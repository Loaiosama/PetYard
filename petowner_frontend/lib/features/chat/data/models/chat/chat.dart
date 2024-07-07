import 'package:equatable/equatable.dart';

import 'datum.dart';

class Chat extends Equatable {
  final String? status;
  final List<ChatDatum>? data;

  const Chat({this.status, this.data});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        status: json['Status'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => ChatDatum.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'Status': status,
        'data': data?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [status, data];
}
