// class PackageClass {
//   PackageClass({
//     this.error,
//     this.msg,
//     this.result,
//   });

//   bool error;
//   String msg;
//   List<Result> result;

//   factory PackageClass.fromJson(Map<String, dynamic> json) => PackageClass(
//         error: json["error"],
//         msg: json["msg"],
//         result: List<Result>.from(
//             json["result"].map((dynamic x) => Result.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         "error": error,
//         "msg": msg,
//         "result":
//             List<dynamic>.from(result.map<dynamic>((dynamic x) => x.toJson())),
//       };
// }

// class Result {
//   Result({
//     this.packageId,
//     this.packageName,
//     this.duration,
//     this.price,
//     this.description,
//     this.purchaseStatus,
//   });
//   String packageId;
//   String packageName;
//   String duration;
//   String price;
//   String description;
//   String purchaseStatus;

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         packageId: json['package_id'],
//         packageName: json["package_name"],
//         duration: json["duration"],
//         price: json["price"],
//         description: json["description"],
//         purchaseStatus: json["purchase_status"],
//       );

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'package_id': packageId,
//         "package_name": packageName,
//         "duration": duration,
//         "price": price,
//         "description": description,
//         "purchase_status": purchaseStatus,
//       };
// }

class PackageClass {
  PackageClass({
    this.error,
    this.msg,
    this.result,
  });

  bool error;
  String msg;
  List<Result> result;

  factory PackageClass.fromJson(Map<String, dynamic> json) => PackageClass(
        error: json["error"] == null ? null : json["error"],
        msg: json["msg"] == null ? null : json["msg"],
        result: json["result"] == null
            ? null
            : List<Result>.from(
                json["result"].map((dynamic x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "error": error == null ? null : error,
        "msg": msg == null ? null : msg,
        "result": result == null
            ? null
            : List<dynamic>.from(result.map<dynamic>((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.packageId,
    this.packageName,
    this.duration,
    this.price,
    this.description,
    this.purchaseStatus,
  });

  String packageId;
  String packageName;
  String duration;
  String price;
  String description;
  String purchaseStatus;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        packageId: json["package_id"] == null ? null : json["package_id"],
        packageName: json["package_name"] == null ? null : json["package_name"],
        duration: json["duration"] == null ? null : json["duration"],
        price: json["price"] == null ? null : json["price"],
        description: json["description"] == null ? null : json["description"],
        purchaseStatus:
            json["purchase_status"] == null ? null : json["purchase_status"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "package_id": packageId == null ? null : packageId,
        "package_name": packageName == null ? null : packageName,
        "duration": duration == null ? null : duration,
        "price": price == null ? null : price,
        "description": description == null ? null : description,
        "purchase_status": purchaseStatus == null ? null : purchaseStatus,
      };
}
