class PetModel {
  String? type;
  String? name;
  String? gender;
  String? breed;
  String? dateOfBirth;
  String? adoptionDate;
  String? weight;
  String? image;
  PetModel(
      {this.type,
      this.name,
      this.gender,
      this.breed,
      this.dateOfBirth,
      this.adoptionDate,
      this.weight});

  PetModel.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    name = json['Name'];
    gender = json['Gender'];
    breed = json['Breed'];
    dateOfBirth = json['Date_of_birth'];
    adoptionDate = json['Adoption_Date'];
    weight = json['Weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Type'] = type;
    data['Name'] = name;
    data['Gender'] = gender;
    data['Breed'] = breed;
    data['Date_of_birth'] = dateOfBirth;
    data['Adoption_Date'] = adoptionDate;
    data['Weight'] = weight;
    return data;
  }
}
