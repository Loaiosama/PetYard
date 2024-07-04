import 'package:equatable/equatable.dart';

import 'service.dart';

class ProviderSorted extends Equatable {
  final int? providerId;
  final String? username;
  final String? phone;
  final String? email;
  final String? bio;
  final DateTime? dateOfBirth;
  final dynamic location;
  final String? image;
  final double? averageRating;
  final String? reviewCount;
  final List<Service>? services;

  const ProviderSorted({
    this.providerId,
    this.username,
    this.phone,
    this.email,
    this.bio,
    this.dateOfBirth,
    this.location,
    this.image,
    this.averageRating,
    this.reviewCount,
    this.services,
  });

  factory ProviderSorted.fromJson(Map<String, dynamic> json) {
    return ProviderSorted(
      providerId: json['provider_id'] as int?,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      location: json['location'] as dynamic,
      image: json['image'] as String?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as String?,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'provider_id': providerId,
        'username': username,
        'phone': phone,
        'email': email,
        'bio': bio,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'location': location,
        'image': image,
        'average_rating': averageRating,
        'review_count': reviewCount,
        'services': services?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props {
    return [
      providerId,
      username,
      phone,
      email,
      bio,
      dateOfBirth,
      location,
      image,
      averageRating,
      reviewCount,
      services,
    ];
  }
}
