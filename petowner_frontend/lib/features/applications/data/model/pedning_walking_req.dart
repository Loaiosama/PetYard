class PendingWalkingRequest {
  int? reserveId;
  int? petId;
  String? name;
  String? image;
  int? ownerId;
  DateTime? startTime;
  DateTime? endTime;
  int? finalPrice;
  String? status;
  double? centerLatitude;
  double? centerLongitude;

  PendingWalkingRequest(
      {this.reserveId,
      this.petId,
      this.name,
      this.image,
      this.ownerId,
      this.startTime,
      this.endTime,
      this.finalPrice,
      this.status,
      this.centerLatitude,
      this.centerLongitude});

  PendingWalkingRequest.fromJson(Map<String, dynamic> json) {
    reserveId = json['reserve_id'];
    petId = json['pet_id'];
    name = json['name'];
    image = json['image'];
    ownerId = json['owner_id'];
    startTime = DateTime.parse(json['start_time']);
    endTime = DateTime.parse(json['end_time']);
    finalPrice = json['final_price'];
    status = json['status'];
    centerLatitude = json['center_latitude'];
    centerLongitude = json['center_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reserve_id'] = this.reserveId;
    data['pet_id'] = this.petId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['owner_id'] = this.ownerId;
    data['start_time'] = this.startTime?.toIso8601String();
    data['end_time'] = this.endTime?.toIso8601String();
    data['final_price'] = this.finalPrice;
    data['status'] = this.status;
    data['center_latitude'] = this.centerLatitude;
    data['center_longitude'] = this.centerLongitude;
    return data;
  }
}
