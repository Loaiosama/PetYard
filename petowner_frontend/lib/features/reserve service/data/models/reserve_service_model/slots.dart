import 'package:equatable/equatable.dart';

class Slots extends Equatable {
  final int? slotId;
  final int? providerId;
  final int? serviceId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? price;

  const Slots({
    this.slotId,
    this.providerId,
    this.serviceId,
    this.startTime,
    this.endTime,
    this.price,
  });

  factory Slots.fromJson(Map<String, dynamic> json) => Slots(
        slotId: json['slot_id'] as int?,
        providerId: json['provider_id'] as int?,
        serviceId: json['service_id'] as int?,
        startTime: json['start_time'] == null
            ? null
            : DateTime.parse(json['start_time'] as String),
        endTime: json['end_time'] == null
            ? null
            : DateTime.parse(json['end_time'] as String),
        price: json['price'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'slot_id': slotId,
        'provider_id': providerId,
        'service_id': serviceId,
        'start_time': startTime?.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'price': price,
      };

  @override
  List<Object?> get props {
    return [
      slotId,
      providerId,
      serviceId,
      startTime,
      endTime,
      price,
    ];
  }
}
