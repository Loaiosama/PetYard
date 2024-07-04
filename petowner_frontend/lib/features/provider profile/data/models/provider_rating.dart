import 'package:equatable/equatable.dart';

class ProviderRating extends Equatable {
  final int? reviewId;
  final int? providerId;
  final int? rateValue;
  final String? comment;
  final DateTime? createdAt;
  final String? ownerName;
  final String? ownerImage;

  const ProviderRating({
    this.reviewId,
    this.providerId,
    this.rateValue,
    this.comment,
    this.createdAt,
    this.ownerName,
    this.ownerImage,
  });

  factory ProviderRating.fromJson(Map<String, dynamic> json) {
    return ProviderRating(
      reviewId: json['review_id'] as int?,
      providerId: json['provider_id'] as int?,
      rateValue: json['rate_value'] as int?,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      ownerName: json['owner_name'] as String?,
      ownerImage: json['owner_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'review_id': reviewId,
        'provider_id': providerId,
        'rate_value': rateValue,
        'comment': comment,
        'created_at': createdAt?.toIso8601String(),
        'owner_name': ownerName,
        'owner_image': ownerImage,
      };

  @override
  List<Object?> get props {
    return [
      reviewId,
      providerId,
      rateValue,
      comment,
      createdAt,
      ownerName,
      ownerImage,
    ];
  }
}
