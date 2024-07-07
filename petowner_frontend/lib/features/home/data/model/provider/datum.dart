import 'package:equatable/equatable.dart';

class Datum extends Equatable {
  final int? providerId;
  final String? username;
  final String? phone;
  final String? email;
  final String? bio;
  final DateTime? dateOfBirth;
  final dynamic location;
  final String? image;
  final num? rate;
  final dynamic? count;
  const Datum({
    this.providerId,
    this.username,
    this.phone,
    this.email,
    this.bio,
    this.dateOfBirth,
    this.location,
    this.image,
    this.rate,
    this.count,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        rate: json['rate_value'] as num,
        count: json['count'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'provider_id': providerId,
        'username': username,
        'phone': phone,
        'email': email,
        'bio': bio,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'location': location,
        'image': image,
        'rate_value': rate,
        'count': count,
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
      rate,
      count,
    ];
  }
}
