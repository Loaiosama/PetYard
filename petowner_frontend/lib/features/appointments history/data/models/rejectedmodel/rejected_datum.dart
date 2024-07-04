import 'package:equatable/equatable.dart';

class RejectedDatum extends Equatable {
  final int? reserveId;
  final int? slotId;
  final int? petId;
  final int? ownerId;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? expirationtime;
  final int? finalPrice;
  final String? type;
  final String? providerName;
  final String? providerEmail;
  final String? providerPhone;
  final String? providerBio;
  final String? providerImage;
  final String? serviceType;
  final DateTime? slotStartTime;
  final DateTime? slotEndTime;
  final int? slotPrice;

  const RejectedDatum({
    this.reserveId,
    this.slotId,
    this.petId,
    this.ownerId,
    this.startTime,
    this.endTime,
    this.expirationtime,
    this.finalPrice,
    this.type,
    this.providerName,
    this.providerEmail,
    this.providerPhone,
    this.providerBio,
    this.providerImage,
    this.serviceType,
    this.slotStartTime,
    this.slotEndTime,
    this.slotPrice,
  });

  factory RejectedDatum.fromJson(Map<String, dynamic> json) => RejectedDatum(
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
        expirationtime: json['expirationtime'] as String?,
        finalPrice: json['final_price'] as int?,
        type: json['type'] as String?,
        providerName: json['provider_name'] as String?,
        providerEmail: json['provider_email'] as String?,
        providerPhone: json['provider_phone'] as String?,
        providerBio: json['provider_bio'] as String?,
        providerImage: json['provider_image'] as String?,
        serviceType: json['service_type'] as String?,
        slotStartTime: json['slot_start_time'] == null
            ? null
            : DateTime.parse(json['slot_start_time'] as String),
        slotEndTime: json['slot_end_time'] == null
            ? null
            : DateTime.parse(json['slot_end_time'] as String),
        slotPrice: json['slot_price'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'reserve_id': reserveId,
        'slot_id': slotId,
        'pet_id': petId,
        'owner_id': ownerId,
        'start_time': startTime?.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'expirationtime': expirationtime,
        'final_price': finalPrice,
        'type': type,
        'provider_name': providerName,
        'provider_email': providerEmail,
        'provider_phone': providerPhone,
        'provider_bio': providerBio,
        'provider_image': providerImage,
        'service_type': serviceType,
        'slot_start_time': slotStartTime?.toIso8601String(),
        'slot_end_time': slotEndTime?.toIso8601String(),
        'slot_price': slotPrice,
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
      expirationtime,
      finalPrice,
      type,
      providerName,
      providerEmail,
      providerPhone,
      providerBio,
      providerImage,
      serviceType,
      slotStartTime,
      slotEndTime,
      slotPrice,
    ];
  }
}
