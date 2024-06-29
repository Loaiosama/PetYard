import 'package:equatable/equatable.dart';

import 'grooming_datum.dart';

class GroomingSlots extends Equatable {
  final String? status;
  final String? message;
  final List<GroomingDatum>? data;

  const GroomingSlots({this.status, this.message, this.data});

  factory GroomingSlots.fromJson(Map<String, dynamic> json) => GroomingSlots(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => GroomingDatum.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [status, message, data];
}
