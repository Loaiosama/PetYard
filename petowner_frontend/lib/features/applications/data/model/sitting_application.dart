class SittingApplication {
  int? applicationId;
  int? reserveId;
  int? providerId;
  String? expirationtime;
  String? applicationStatus;
  String? applicationDate;
  String? providerName;
  String? providerImage;
  int? providerRating;
  String? reviewCount;

  SittingApplication(
      {this.applicationId,
      this.reserveId,
      this.providerId,
      this.expirationtime,
      this.applicationStatus,
      this.applicationDate,
      this.providerName,
      this.providerImage,
      this.providerRating,
      this.reviewCount});

  SittingApplication.fromJson(Map<String, dynamic> json) {
    applicationId = json['application_id'];
    reserveId = json['reserve_id'];
    providerId = json['provider_id'];
    expirationtime = json['expirationtime'];
    applicationStatus = json['application_status'];
    applicationDate = json['application_date'];
    providerName = json['provider_name'];
    providerImage = json['provider_image'];
    providerRating = json['provider_rating'];
    reviewCount = json['review_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['application_id'] = this.applicationId;
    data['reserve_id'] = this.reserveId;
    data['provider_id'] = this.providerId;
    data['expirationtime'] = this.expirationtime;
    data['application_status'] = this.applicationStatus;
    data['application_date'] = this.applicationDate;
    data['provider_name'] = this.providerName;
    data['provider_image'] = this.providerImage;
    data['provider_rating'] = this.providerRating;
    data['review_count'] = this.reviewCount;
    return data;
  }
}
