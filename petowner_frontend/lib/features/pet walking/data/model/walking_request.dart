class WalkingRequest {
  int? petID;
  WalkingLocation? location;
  int? radius;
  DateTime? startTime;
  DateTime? endTime;
  double? finalPrice;

  WalkingRequest(
      {this.petID,
      this.location,
      this.radius,
      this.startTime,
      this.endTime,
      this.finalPrice});

  WalkingRequest.fromJson(Map<String, dynamic> json) {
    petID = json['Pet_ID'];
    location = json['Location'] != null
        ? WalkingLocation.fromJson(json['Location'])
        : null;
    radius = json['Radius'];
    startTime =
        json['Start_time'] != null ? DateTime.parse(json['Start_time']) : null;
    endTime =
        json['End_time'] != null ? DateTime.parse(json['End_time']) : null;
    finalPrice =
        json['Final_Price'] != null ? json['Final_Price'].toDouble() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Pet_ID'] = this.petID;
    if (this.location != null) {
      data['Location'] = this.location!.toJson();
    }
    data['Radius'] = this.radius;
    data['Start_time'] = this.startTime?.toIso8601String();
    data['End_time'] = this.endTime?.toIso8601String();
    data['Final_Price'] = this.finalPrice;
    return data;
  }
}

class WalkingLocation {
  double? x;
  double? y;

  WalkingLocation({this.x, this.y});

  WalkingLocation.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
