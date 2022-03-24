class LocationModel {
  LocationModel({
    this.error,
    this.msg,
    this.locationList,
  });

  bool error;
  String msg;
  List<LocationListModel> locationList;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        error: json["error"] == null ? null : json["error"],
        msg: json["msg"] == null ? null : json["msg"],
        locationList: json["result"] == null
            ? null
            : List<LocationListModel>.from(json["result"]
                .map((dynamic x) => LocationListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "error": error == null ? null : error,
        "msg": msg == null ? null : msg,
        "result": locationList == null
            ? null
            : List<dynamic>.from(locationList.map<dynamic>((x) => x.toJson())),
      };
}

class LocationListModel {
  LocationListModel({
    this.locationId,
    this.locationName,
  });

  String locationId;
  String locationName;

  factory LocationListModel.fromJson(Map<String, dynamic> json) =>
      LocationListModel(
        locationId: json["location_id"] == null ? null : json["location_id"],
        locationName:
            json["location_name"] == null ? null : json["location_name"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "location_id": locationId == null ? null : locationId,
        "location_name": locationName == null ? null : locationName,
      };
}
