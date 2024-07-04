class ReservationUpdate {
  int? slotId;
  int? petId;
  int? ownerId;
  DateTime? startTime; // Changed type to DateTime
  DateTime? endTime; // Changed type to DateTime
  String? type;

  ReservationUpdate({
    this.slotId,
    this.petId,
    this.ownerId,
    this.startTime,
    this.endTime,
    this.type,
  });

  ReservationUpdate.fromJson(Map<String, dynamic> json) {
    slotId = json['slot_id'];
    petId = json['pet_id'];
    ownerId = json['owner_id'];
    startTime =
        json['start_time'] != null ? DateTime.parse(json['start_time']) : null;
    endTime =
        json['end_time'] != null ? DateTime.parse(json['end_time']) : null;
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_id'] = this.slotId;
    data['pet_id'] = this.petId;
    data['owner_id'] = this.ownerId;
    data['start_time'] = this
        .startTime
        ?.toIso8601String(); // Convert DateTime to ISO 8601 string
    data['end_time'] =
        this.endTime?.toIso8601String(); // Convert DateTime to ISO 8601 string
    data['Type'] = this.type;
    return data;
  }
}
