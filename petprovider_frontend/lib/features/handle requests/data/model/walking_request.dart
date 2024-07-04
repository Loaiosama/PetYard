class PendingWalkingRequest {
  int? reserveId;
  int? petId;
  int? ownerId;
  DateTime? startTime;
  DateTime? endTime;
  int? finalPrice;
  String? status;
  int? providerId;
  double? centerLatitude;
  double? centerLongitude;
  String? petName;
  String? petImage;

  PendingWalkingRequest(
      {this.reserveId,
      this.petId,
      this.ownerId,
      this.startTime,
      this.endTime,
      this.finalPrice,
      this.status,
      this.providerId,
      this.centerLatitude,
      this.centerLongitude,
      this.petName,
      this.petImage});

  PendingWalkingRequest.fromJson(Map<String, dynamic> json) {
    reserveId = json['reserve_id'];
    petId = json['pet_id'];
    ownerId = json['owner_id'];
    startTime =
        json['start_time'] != null ? DateTime.parse(json['start_time']) : null;
    endTime =
        json['end_time'] != null ? DateTime.parse(json['end_time']) : null;
    finalPrice = json['final_price'];
    status = json['status'];
    providerId = json['provider_id'];
    centerLatitude = json['center_latitude'];
    centerLongitude = json['center_longitude'];
    petName = json['pet_name'];
    petImage = json['pet_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reserve_id'] = this.reserveId;
    data['pet_id'] = this.petId;
    data['owner_id'] = this.ownerId;
    data['start_time'] = this.startTime?.toIso8601String();
    data['end_time'] = this.endTime?.toIso8601String();
    data['final_price'] = this.finalPrice;
    data['status'] = this.status;
    data['provider_id'] = this.providerId;
    data['center_latitude'] = this.centerLatitude;
    data['center_longitude'] = this.centerLongitude;
    data['pet_name'] = this.petName;
    data['pet_image'] = this.petImage;
    return data;
  }
}
