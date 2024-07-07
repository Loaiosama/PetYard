import 'package:equatable/equatable.dart';

import 'upcoming_datum.dart';

class UpcomingEvents extends Equatable {
  final String? status;
  final String? message;
  final List<UpcomingDatum>? data;

  const UpcomingEvents({this.status, this.message, this.data});

  factory UpcomingEvents.fromJson(Map<String, dynamic> json) {
    return UpcomingEvents(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UpcomingDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [status, message, data];
}
