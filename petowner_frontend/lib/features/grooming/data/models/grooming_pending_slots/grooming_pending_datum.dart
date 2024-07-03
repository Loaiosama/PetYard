import 'package:equatable/equatable.dart';

class GroomingPendingDatum extends Equatable {
  final int? slotId;
  final int? providerId;
  final DateTime? startTime;
  final DateTime? endTime;

  const GroomingPendingDatum(
      {this.slotId, this.providerId, this.startTime, this.endTime});

  factory GroomingPendingDatum.fromJson(Map<String, dynamic> json) =>
      GroomingPendingDatum(
        slotId: json['slot_id'] as int?,
        providerId: json['provider_id'] as int?,
        startTime: json['start_time'] == null
            ? null
            : DateTime.parse(json['start_time'] as String),
        endTime: json['end_time'] == null
            ? null
            : DateTime.parse(json['end_time'] as String),
      );

  Map<String, dynamic> toJson() => {
        'slot_id': slotId,
        'provider_id': providerId,
        'start_time': startTime?.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
      };

  @override
  List<Object?> get props => [slotId, providerId, startTime, endTime];
}
