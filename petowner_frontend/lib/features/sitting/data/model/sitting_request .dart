class SittingRequest {
  int? petID;
  Location? location;
  DateTime? startTime;
  DateTime? endTime;
  double? finalPrice;

  SittingRequest({
    this.petID,
    this.location,
    this.startTime,
    this.endTime,
    this.finalPrice,
  });

  SittingRequest.fromJson(Map<String, dynamic> json) {
    petID = json['Pet_ID'];
    location =
        json['Location'] != null ? Location.fromJson(json['Location']) : null;
    startTime =
        json['Start_time'] != null ? DateTime.parse(json['Start_time']) : null;
    endTime =
        json['End_time'] != null ? DateTime.parse(json['End_time']) : null;
    finalPrice = json['Final_Price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Pet_ID'] = petID;
    if (location != null) {
      data['Location'] = location!.toJson();
    }
    data['Start_time'] = startTime?.toIso8601String();
    data['End_time'] = endTime?.toIso8601String();
    data['Final_Price'] = finalPrice;
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
