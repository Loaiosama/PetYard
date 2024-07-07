import 'package:equatable/equatable.dart';

class UpcomingDatum extends Equatable {
  final String? serviceType;
  final int? reserveId;
  final int? petId;
  final String? petName;
  final String? petImage;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? finalPrice;
  final String? ownerFirstName;
  final String? ownerLastName;
  final String? ownerEmail;
  final String? ownerPhone;
  final dynamic ownerLocation;
  final String? ownerImage;
  final String? status;

  const UpcomingDatum({
    this.serviceType,
    this.reserveId,
    this.petId,
    this.petName,
    this.petImage,
    this.startTime,
    this.endTime,
    this.finalPrice,
    this.ownerFirstName,
    this.ownerLastName,
    this.ownerEmail,
    this.ownerPhone,
    this.ownerLocation,
    this.ownerImage,
    this.status,
  });

  factory UpcomingDatum.fromJson(Map<String, dynamic> json) => UpcomingDatum(
        serviceType: json['service_type'] as String?,
        reserveId: json['reserve_id'] as int?,
        petId: json['pet_id'] as int?,
        petName: json['pet_name'] as String?,
        petImage: json['pet_image'] as String?,
        startTime: json['start_time'] == null
            ? null
            : DateTime.parse(json['start_time'] as String),
        endTime: json['end_time'] == null
            ? null
            : DateTime.parse(json['end_time'] as String),
        finalPrice: json['final_price'] as int?,
        ownerFirstName: json['owner_first_name'] as String?,
        ownerLastName: json['owner_last_name'] as String?,
        ownerEmail: json['owner_email'] as String?,
        ownerPhone: json['owner_phone'] as String?,
        ownerLocation: json['owner_location'] as dynamic,
        ownerImage: json['owner_image'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'service_type': serviceType,
        'reserve_id': reserveId,
        'pet_id': petId,
        'pet_name': petName,
        'pet_image': petImage,
        'start_time': startTime?.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'final_price': finalPrice,
        'owner_first_name': ownerFirstName,
        'owner_last_name': ownerLastName,
        'owner_email': ownerEmail,
        'owner_phone': ownerPhone,
        'owner_location': ownerLocation,
        'owner_image': ownerImage,
        'status': status,
      };

  @override
  List<Object?> get props {
    return [
      serviceType,
      reserveId,
      petId,
      petName,
      petImage,
      startTime,
      endTime,
      finalPrice,
      ownerFirstName,
      ownerLastName,
      ownerEmail,
      ownerPhone,
      ownerLocation,
      ownerImage,
      status,
    ];
  }
}
