class CityModel {
  CityModel({
    this.error,
    this.msg,
    this.cityList,
  });

  bool error;
  String msg;
  List<CityListModel> cityList;

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        error: json["error"],
        msg: json["msg"],
        cityList: List<CityListModel>.from(
            json["result"].map((dynamic x) => CityListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "error": error,
        "msg": msg,
        "result": List<dynamic>.from(
            cityList.map<dynamic>((dynamic x) => x.toJson())),
      };
}

class CityListModel {
  CityListModel({
    this.cityId,
    this.cityName,
  });

  String cityId;
  String cityName;

  factory CityListModel.fromJson(Map<String, dynamic> json) => CityListModel(
        cityId: json["city_id"],
        cityName: json["city_name"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "city_id": cityId,
        "city_name": cityName,
      };
}
