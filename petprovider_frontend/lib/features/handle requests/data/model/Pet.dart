class Pet {
  int? petId;
  String? type;
  String? name;
  String? gender;
  String? breed;
  String? dateOfBirth;
  String? adoptionDate;
  int? weight;
  String? image;
  String? bio;
  int? ownerId;

  Pet(
      {this.petId,
      this.type,
      this.name,
      this.gender,
      this.breed,
      this.dateOfBirth,
      this.adoptionDate,
      this.weight,
      this.image,
      this.bio,
      this.ownerId});

  Pet.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id'];
    type = json['type'];
    name = json['name'];
    gender = json['gender'];
    breed = json['breed'];
    dateOfBirth = json['date_of_birth'];
    adoptionDate = json['adoption_date'];
    weight = json['weight'];
    image = json['image'];
    bio = json['bio'];
    ownerId = json['owner_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pet_id'] = this.petId;
    data['type'] = this.type;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['breed'] = this.breed;
    data['date_of_birth'] = this.dateOfBirth;
    data['adoption_date'] = this.adoptionDate;
    data['weight'] = this.weight;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['owner_id'] = this.ownerId;
    return data;
  }
}
