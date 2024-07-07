class GroomingReservation {
  String? serviceType;
  int? reserveId;
  int? petId;
  String? petName;
  String? petImage;
  DateTime? startTime;
  DateTime? endTime;
  int? finalPrice;
  int? ownerId;
  String? ownerFirstName;
  String? ownerLastName;
  String? ownerEmail;
  String? ownerPhone;
  Location? ownerLocation;
  String? ownerImage;

  GroomingReservation(
      {this.serviceType,
      this.reserveId,
      this.petId,
      this.petName,
      this.petImage,
      this.startTime,
      this.endTime,
      this.finalPrice,
      this.ownerId,
      this.ownerFirstName,
      this.ownerLastName,
      this.ownerEmail,
      this.ownerPhone,
      this.ownerLocation,
      this.ownerImage});

  GroomingReservation.fromJson(Map<String, dynamic> json) {
    serviceType = json['service_type'];
    reserveId = json['reserve_id'];
    petId = json['pet_id'];
    petName = json['pet_name'];
    petImage = json['pet_image'];
    startTime = DateTime.parse(json['start_time']);
    endTime = DateTime.parse(json['end_time']);
    finalPrice = json['final_price'];
    ownerId = json['owner_id'];
    ownerFirstName = json['owner_first_name'];
    ownerLastName = json['owner_last_name'];
    ownerEmail = json['owner_email'];
    ownerPhone = json['owner_phone'];
    ownerLocation = json['owner_location'] != null
        ? Location.fromJson(json['owner_location'])
        : null;
    ownerImage = json['owner_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_type'] = this.serviceType;
    data['reserve_id'] = this.reserveId;
    data['pet_id'] = this.petId;
    data['pet_name'] = this.petName;
    data['pet_image'] = this.petImage;
    data['start_time'] = this.startTime?.toIso8601String();
    data['end_time'] = this.endTime?.toIso8601String();
    data['final_price'] = this.finalPrice;
    data['owner_id'] = this.ownerId;
    data['owner_first_name'] = this.ownerFirstName;
    data['owner_last_name'] = this.ownerLastName;
    data['owner_email'] = this.ownerEmail;
    data['owner_phone'] = this.ownerPhone;
    if (this.ownerLocation != null) {
      data['owner_location'] = this.ownerLocation!.toJson();
    }
    data['owner_image'] = this.ownerImage;
    return data;
  }
}

class Location {
  double? x;
  double? y;

  Location({this.x, this.y});

  Location.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
