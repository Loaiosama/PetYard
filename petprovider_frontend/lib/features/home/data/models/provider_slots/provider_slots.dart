import 'package:equatable/equatable.dart';

import 'provider_datum.dart';

class ProviderSlots extends Equatable {
  final String? status;
  final String? message;
  final List<ProviderSlotData>? data;

  const ProviderSlots({this.status, this.message, this.data});

  factory ProviderSlots.fromJson(Map<String, dynamic> json) => ProviderSlots(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => ProviderSlotData.fromJson(e as Map<String, dynamic>))
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
