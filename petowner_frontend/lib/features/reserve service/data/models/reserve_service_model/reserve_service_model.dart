import 'package:equatable/equatable.dart';

import 'reserved_slots.dart';
import 'slots.dart';

class ReserveServiceModel extends Equatable {
  final String? status;
  final String? message;
  final List<Slots>? data;
  final List<ReservedSlots>? data1;

  const ReserveServiceModel({
    this.status,
    this.message,
    this.data,
    this.data1,
  });

  factory ReserveServiceModel.fromJson(Map<String, dynamic> json) {
    return ReserveServiceModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Slots.fromJson(e as Map<String, dynamic>))
          .toList(),
      data1: (json['data1'] as List<dynamic>?)
          ?.map((e) => ReservedSlots.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
        'data1': data1?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [status, message, data, data1];
}
