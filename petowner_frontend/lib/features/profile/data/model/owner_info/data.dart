import 'package:equatable/equatable.dart';

class Data extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final DateTime? dateOfBirth;
  final dynamic location;
  final String? image;

  const Data({
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.dateOfBirth,
    this.location,
    this.image,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        dateOfBirth: json['date_of_birth'] == null
            ? null
            : DateTime.parse(json['date_of_birth'] as String),
        location: json['location'] as dynamic,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'location': location,
        'image': image,
      };

  @override
  List<Object?> get props {
    return [
      firstName,
      lastName,
      phone,
      email,
      dateOfBirth,
      location,
      image,
    ];
  }
}
