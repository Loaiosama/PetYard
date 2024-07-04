class UpdateApplication {
  int? reserveID;
  int? providerID;

  UpdateApplication({this.reserveID, this.providerID});

  UpdateApplication.fromJson(Map<String, dynamic> json) {
    reserveID = json['Reserve_ID'];
    providerID = json['Provider_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Reserve_ID'] = this.reserveID;
    data['Provider_ID'] = this.providerID;
    return data;
  }
}
