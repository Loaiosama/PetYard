import 'package:equatable/equatable.dart';

class Datum extends Equatable {
  final int? petId;
  final String? type;
  final String? name;
  final String? gender;
  final String? breed;
  final DateTime? dateOfBirth;
  final DateTime? adoptionDate;
  final double? weight;
  final String? image;
  final String? bio;
  final int? ownerId;

  const Datum({
    this.petId,
    this.type,
    this.name,
    this.gender,
    this.breed,
    this.dateOfBirth,
    this.adoptionDate,
    this.weight,
    this.image,
    this.ownerId,
    this.bio,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      petId: json['pet_id'] as int?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      breed: json['breed'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      adoptionDate: json['adoption_date'] == null
          ? null
          : DateTime.parse(json['adoption_date'] as String),
      weight: (json['weight'] as num?)?.toDouble(),
      image: json['image'] as String?,
      ownerId: json['owner_id'] as int?,
      bio: json['bio'] as String?);

  Map<String, dynamic> toJson() => {
        'pet_id': petId,
        'type': type,
        'name': name,
        'gender': gender,
        'breed': breed,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'adoption_date': adoptionDate?.toIso8601String(),
        'weight': weight,
        'image': image,
        'owner_id': ownerId,
        'bio': bio,
      };

  @override
  List<Object?> get props {
    return [
      petId,
      type,
      name,
      gender,
      breed,
      dateOfBirth,
      adoptionDate,
      weight,
      image,
      ownerId,
      bio,
    ];
  }
}
