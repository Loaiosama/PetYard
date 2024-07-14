import 'package:equatable/equatable.dart';

class Providerinfo extends Equatable {
  final int? providerId;
  final String? username;
  final String? password;
  final String? phone;
  final String? email;
  final String? bio;
  final dynamic resettoken;
  final DateTime? dateOfBirth;
  final dynamic location;
  final String? image;
  final num? rate;
  final dynamic reviewCount;
  const Providerinfo({
    this.providerId,
    this.username,
    this.password,
    this.phone,
    this.email,
    this.bio,
    this.resettoken,
    this.dateOfBirth,
    this.location,
    this.image,
    this.rate,
    this.reviewCount,
  });

  factory Providerinfo.fromJson(Map<String, dynamic> json) => Providerinfo(
        providerId: json['provider_id'] as int?,
        username: json['username'] as String?,
        password: json['password'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        bio: json['bio'] as String?,
        resettoken: json['resettoken'] as dynamic,
        dateOfBirth: json['date_of_birth'] == null
            ? null
            : DateTime.parse(json['date_of_birth'] as String),
        location: json['location'] as dynamic,
        image: json['image'] as String?,
        rate: json['rating'] as num?,
        reviewCount: json['reviewCount'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'provider_id': providerId,
        'username': username,
        'password': password,
        'phone': phone,
        'email': email,
        'bio': bio,
        'resettoken': resettoken,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'location': location,
        'image': image,
        'rating': rate,
        'reviewCount': reviewCount,
      };

  @override
  List<Object?> get props {
    return [
      providerId,
      username,
      password,
      phone,
      email,
      bio,
      resettoken,
      dateOfBirth,
      location,
      image,
      rate,
      reviewCount
    ];
  }
}
