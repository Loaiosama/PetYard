class PetModel {
  String? type;
  String? name;
  String? gender;
  String? breed;
  String? dateOfBirth;
  String? adoptionDate;
  String? weight;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.type;
    data['Name'] = this.name;
    data['Gender'] = this.gender;
    data['Breed'] = this.breed;
    data['Date_of_birth'] = this.dateOfBirth;
    data['Adoption_Date'] = this.adoptionDate;
    data['Weight'] = this.weight;
    return data;
  }
}