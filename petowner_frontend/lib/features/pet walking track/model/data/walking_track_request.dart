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

class WalkingTrackRequest {
  String? serviceType;
  int? reserveId;
  int? petId;
  String? petName;
  String? petImage;
  DateTime? startTime;
  DateTime? endTime;
  int? finalPrice;
  String? status;
  String? providerUsername;
  String? providerEmail;
  String? providerPhone;
  Location? providerLocation;
  String? providerImage;
  double? geofenceLatitude;
  double? geofenceLongitude;
  int? geofenceRadius;

  WalkingTrackRequest(
      {this.serviceType,
      this.reserveId,
      this.petId,
      this.petName,
      this.petImage,
      this.startTime,
      this.endTime,
      this.finalPrice,
      this.status,
      this.providerUsername,
      this.providerEmail,
      this.providerPhone,
      this.providerLocation,
      this.providerImage,
      this.geofenceLatitude,
      this.geofenceLongitude,
      this.geofenceRadius});

  WalkingTrackRequest.fromJson(Map<String, dynamic> json) {
    serviceType = json['service_type'];
    reserveId = json['reserve_id'];
    petId = json['pet_id'];
    petName = json['pet_name'];
    petImage = json['pet_image'];
    startTime = DateTime.parse(json['start_time']);
    endTime = DateTime.parse(json['end_time']);
    finalPrice = json['final_price'];
    status = json['status'];
    providerUsername = json['provider_username'];
    providerEmail = json['provider_email'];
    providerPhone = json['provider_phone'];
    providerLocation = json['provider_location'] != null
        ? Location.fromJson(json['provider_location'])
        : null;
    providerImage = json['provider_image'];
    geofenceLatitude = json['geofence_latitude'];
    geofenceLongitude = json['geofence_longitude'];
    geofenceRadius = json['geofence_radius'];
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
    data['status'] = this.status;
    data['provider_username'] = this.providerUsername;
    data['provider_email'] = this.providerEmail;
    data['provider_phone'] = this.providerPhone;
    if (this.providerLocation != null) {
      data['provider_location'] = this.providerLocation!.toJson();
    }
    data['provider_image'] = this.providerImage;
    data['geofence_latitude'] = this.geofenceLatitude;
    data['geofence_longitude'] = this.geofenceLongitude;
    data['geofence_radius'] = this.geofenceRadius;
    return data;
  }
}
