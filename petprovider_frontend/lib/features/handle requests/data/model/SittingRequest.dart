class SittingRequests {
  int? reserveId;
  int? petId;
  int? ownerId;
  Location? location;
  DateTime? startTime; // Updated to DateTime type
  DateTime? endTime; // Updated to DateTime type
  int? finalPrice;
  String? status;
  int? providerId;

  SittingRequests({
    this.reserveId,
    this.petId,
    this.ownerId,
    this.location,
    this.startTime,
    this.endTime,
    this.finalPrice,
    this.status,
    this.providerId,
  });

  SittingRequests.fromJson(Map<String, dynamic> json) {
    reserveId = json['reserve_id'];
    petId = json['pet_id'];
    ownerId = json['owner_id'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    startTime = json['start_time'] != null
        ? DateTime.parse(json['start_time'])
        : null; // Convert string to DateTime
    endTime = json['end_time'] != null
        ? DateTime.parse(json['end_time'])
        : null; // Convert string to DateTime
    finalPrice = json['final_price'];
    status = json['status'];
    providerId = json['provider_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reserve_id'] = reserveId;
    data['pet_id'] = petId;
    data['owner_id'] = ownerId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['start_time'] =
        startTime?.toIso8601String(); // Convert DateTime to string
    data['end_time'] = endTime?.toIso8601String(); // Convert DateTime to string
    data['final_price'] = finalPrice;
    data['status'] = status;
    data['provider_id'] = providerId;
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
