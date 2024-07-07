import 'package:intl/intl.dart';

class WalkingRequest {
  String? serviceType;
  int? reserveId;
  int? petId;
  String? petName;
  String? petImage;
  DateTime? startTime;
  DateTime? endTime;
  int? finalPrice;
  String? status;
  String? ownerFirstName;
  String? ownerLastName;
  String? ownerEmail;
  String? ownerPhone;
  Location? ownerLocation;
  String? ownerImage;

  WalkingRequest(
      {this.serviceType,
      this.reserveId,
      this.petId,
      this.petName,
      this.petImage,
      this.startTime,
      this.endTime,
      this.finalPrice,
      this.status,
      this.ownerFirstName,
      this.ownerLastName,
      this.ownerEmail,
      this.ownerPhone,
      this.ownerLocation,
      this.ownerImage});

  WalkingRequest.fromJson(Map<String, dynamic> json) {
    serviceType = json['service_type'];
    reserveId = json['reserve_id'];
    petId = json['pet_id'];
    petName = json['pet_name'];
    petImage = json['pet_image'];
    startTime = DateTime.parse(json['start_time']);
    endTime = DateTime.parse(json['end_time']);
    finalPrice = json['final_price'];
    status = json['status'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_type'] = serviceType;
    data['reserve_id'] = reserveId;
    data['pet_id'] = petId;
    data['pet_name'] = petName;
    data['pet_image'] = petImage;
    data['start_time'] = startTime?.toIso8601String();
    data['end_time'] = endTime?.toIso8601String();
    data['final_price'] = finalPrice;
    data['status'] = status;
    data['owner_first_name'] = ownerFirstName;
    data['owner_last_name'] = ownerLastName;
    data['owner_email'] = ownerEmail;
    data['owner_phone'] = ownerPhone;
    if (ownerLocation != null) {
      data['owner_location'] = ownerLocation!.toJson();
    }
    data['owner_image'] = ownerImage;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}
