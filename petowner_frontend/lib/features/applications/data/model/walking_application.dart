class WalkingApplication {
  int? applicationId;
  int? reserveId;
  int? providerId;
  String? expirationtime;
  String? applicationStatus;
  DateTime? applicationDate;
  String? username;
  String? image;

  WalkingApplication(
      {this.applicationId,
      this.reserveId,
      this.providerId,
      this.expirationtime,
      this.applicationStatus,
      this.applicationDate,
      this.username,
      this.image});

  WalkingApplication.fromJson(Map<String, dynamic> json) {
    applicationId = json['application_id'];
    reserveId = json['reserve_id'];
    providerId = json['provider_id'];
    expirationtime = json['expirationtime'];
    applicationStatus = json['application_status'];
    applicationDate = DateTime.parse(json['application_date']);
    username = json['username'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['application_id'] = this.applicationId;
    data['reserve_id'] = this.reserveId;
    data['provider_id'] = this.providerId;
    data['expirationtime'] = this.expirationtime;
    data['application_status'] = this.applicationStatus;
    data['application_date'] = this.applicationDate?.toIso8601String();
    data['username'] = this.username;
    data['image'] = this.image;
    return data;
  }
}
