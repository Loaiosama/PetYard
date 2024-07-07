import 'package:equatable/equatable.dart';

class Datum extends Equatable {
  final int? reserveId;
  final int? petId;
  final String? petName;
  final String? petImage;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? finalPrice;
  final String? type;
  final String? providerName;
  final String? providerEmail;
  final String? providerPhone;
  final String? providerBio;
  final String? providerImage;
  final String? serviceType;
  final num? providerRating;
  final dynamic reviewCount;
  final int? providerId;
  const Datum({
    this.reserveId,
    this.petId,
    this.petName,
    this.petImage,
    this.startTime,
    this.endTime,
    this.finalPrice,
    this.type,
    this.providerName,
    this.providerEmail,
    this.providerPhone,
    this.providerBio,
    this.providerImage,
    this.serviceType,
    this.providerRating,
    this.reviewCount,
    this.providerId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        type: json['type'] as String?,
        providerName: json['provider_name'] as String?,
        providerEmail: json['provider_email'] as String?,
        providerPhone: json['provider_phone'] as String?,
        providerBio: json['provider_bio'] as String?,
        providerImage: json['provider_image'] as String?,
        serviceType: json['service_type'] as String?,
        providerRating: json['provider_rating'] as num?,
        providerId: json['provider_id'] as int?,
        reviewCount: json['review_count'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'reserve_id': reserveId,
        'pet_id': petId,
        'pet_name': petName,
        'pet_image': petImage,
        'start_time': startTime?.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'final_price': finalPrice,
        'type': type,
        'provider_name': providerName,
        'provider_email': providerEmail,
        'provider_phone': providerPhone,
        'provider_bio': providerBio,
        'provider_image': providerImage,
        'service_type': serviceType,
        'provider_rating': providerRating,
        'review_count': reviewCount,
        'provider_id': providerId,
      };

  @override
  List<Object?> get props {
    return [
      reserveId,
      petId,
      petName,
      petImage,
      startTime,
      endTime,
      finalPrice,
      type,
      providerName,
      providerEmail,
      providerPhone,
      providerBio,
      providerImage,
      serviceType,
      providerRating,
      reviewCount,
      providerId,
    ];
  }
}
