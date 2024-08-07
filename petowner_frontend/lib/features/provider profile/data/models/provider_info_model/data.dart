import 'package:equatable/equatable.dart';
import 'package:petowner_frontend/features/provider%20profile/data/models/provider_info_model/location.dart';

class Data extends Equatable {
  final int? providerId;
  final String? username;
  final String? phone;
  final String? email;
  final String? bio;
  final DateTime? dateOfBirth;
  final Location? location;
  final String? image;
  final int? age; // Added age field

  const Data({
    this.providerId,
    this.username,
    this.phone,
    this.email,
    this.bio,
    this.dateOfBirth,
    this.location,
    this.image,
    this.age,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        providerId: json['provider_id'] as int?,
        username: json['username'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        bio: json['bio'] as String?,
        dateOfBirth: json['date_of_birth'] == null
            ? null
            : DateTime.parse(json['date_of_birth'] as String),
        location: json['location'] == null
            ? null
            : Location.fromJson(json['location'] as Map<String, dynamic>),
        image: json['image'] as String?,
        age: json['age'] as int?, // Added age field
      );

  Map<String, dynamic> toJson() => {
        'provider_id': providerId,
        'username': username,
        'phone': phone,
        'email': email,
        'bio': bio,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'location': location?.toJson(),
        'image': image,
        'age': age, // Added age field
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
      age, // Added age field
    ];
  }
}

class Service extends Equatable {
  final int? serviceId;
  final int? providerId;
  final String? type;

  const Service({this.serviceId, this.providerId, this.type});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        serviceId: json['service_id'] as int?,
        providerId: json['provider_id'] as int?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'service_id': serviceId,
        'provider_id': providerId,
        'type': type,
      };

  @override
  List<Object?> get props => [serviceId, providerId, type];
}
