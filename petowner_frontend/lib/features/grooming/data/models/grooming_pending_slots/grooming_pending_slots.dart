import 'package:equatable/equatable.dart';

import 'grooming_pending_datum.dart';

class GroomingPendingSlots extends Equatable {
  final String? status;
  final String? message;
  final List<GroomingPendingDatum>? data;

  const GroomingPendingSlots({this.status, this.message, this.data});

  factory GroomingPendingSlots.fromJson(Map<String, dynamic> json) {
    return GroomingPendingSlots(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => GroomingPendingDatum.fromJson(e as Map<String, dynamic>))
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
