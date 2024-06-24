import 'package:equatable/equatable.dart';

class ReservedSlots extends Equatable {
  final int? reserveId;
  final int? slotId;
  final int? petId;
  final int? ownerId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? finalPrice;
  final String? type;

  const ReservedSlots({
    this.reserveId,
    this.slotId,
    this.petId,
    this.ownerId,
    this.startTime,
    this.endTime,
    this.finalPrice,
    this.type,
  });

  factory ReservedSlots.fromJson(Map<String, dynamic> json) => ReservedSlots(
        reserveId: json['reserve_id'] as int?,
        slotId: json['slot_id'] as int?,
        petId: json['pet_id'] as int?,
        ownerId: json['owner_id'] as int?,
        startTime: json['start_time'] == null
            ? null
            : DateTime.parse(json['start_time'] as String),
        endTime: json['end_time'] == null
            ? null
            : DateTime.parse(json['end_time'] as String),
        finalPrice: json['final_price'] as int?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'reserve_id': reserveId,
        'slot_id': slotId,
        'pet_id': petId,
        'owner_id': ownerId,
        'start_time': startTime?.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'final_price': finalPrice,
        'type': type,
      };

  @override
  List<Object?> get props {
    return [
      reserveId,
      slotId,
      petId,
      ownerId,
      startTime,
      endTime,
      finalPrice,
      type,
    ];
  }
}
