class PendingSittingReq {
  int? reserveId;
  int? petId;
  int? ownerId;
  Location? location;
  DateTime? startTime;
  DateTime? endTime;
  int? finalPrice;
  String? status;
  String? name;
  String? image;

  PendingSittingReq({
    this.reserveId,
    this.petId,
    this.ownerId,
    this.location,
    this.startTime,
    this.endTime,
    this.finalPrice,
    this.status,
    this.name,
    this.image,
  });

  PendingSittingReq.fromJson(Map<String, dynamic> json) {
    reserveId = json['reserve_id'];
    petId = json['pet_id'];
    ownerId = json['owner_id'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    startTime =
        json['start_time'] != null ? DateTime.parse(json['start_time']) : null;
    endTime =
        json['end_time'] != null ? DateTime.parse(json['end_time']) : null;
    finalPrice = json['final_price'];
    status = json['status'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reserve_id'] = reserveId;
    data['pet_id'] = petId;
    data['owner_id'] = ownerId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['start_time'] = startTime?.toIso8601String();
    data['end_time'] = endTime?.toIso8601String();
    data['final_price'] = finalPrice;
    data['status'] = status;
    data['name'] = name;
    data['image'] = image;
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
