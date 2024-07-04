class Location {
  double? x;
  double? y;

  Location({this.x, this.y});

  Location.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}

class Owner {
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  DateTime? dateOfBirth; // Updated to DateTime type
  Location? location; // Updated to use the Location class
  String? image;

  Owner(
      {this.firstName,
      this.lastName,
      this.phone,
      this.email,
      this.dateOfBirth,
      this.location,
      this.image});

  Owner.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'] != null
        ? DateTime.parse(json['date_of_birth'])
        : null; // Parsing dateOfBirth to DateTime
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null; // Parsing location to Location object
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['date_of_birth'] =
        dateOfBirth?.toIso8601String(); // Converting dateOfBirth to String
    data['location'] = location?.toJson(); // Converting location to JSON
    data['image'] = image;
    return data;
  }
}
