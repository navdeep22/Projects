// class PurchageHistoryModel {
//   PurchageHistoryModel({
//     this.error,
//     this.msg,
//     this.result,
//   });

//   bool error;
//   String msg;
//   List<Result> result;

//   factory PurchageHistoryModel.fromJson(Map<String, dynamic> json) =>
//       PurchageHistoryModel(
//         error: json["error"],
//         msg: json["msg"],
//         result: List<Result>.from(
//             json["result"].map((dynamic x) => Result.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         "error": error,
//         "msg": msg,
//         "result": List<dynamic>.from(result.map<dynamic>((x) => x.toJson())),
//       };
// }

// class Result {
//   Result({
//     this.purchaseDate,
//     this.packageName,
//     this.price,
//     this.orderId,
//     this.status,
//   });

//   String purchaseDate;
//   String packageName;
//   String price;
//   String orderId;
//   String status;

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         purchaseDate: json["purchase_date"],
//         packageName: json["package_name"],
//         price: json["price"],
//         orderId: json["order_id"],
//         status: json["status"],
//       );

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         "purchase_date": purchaseDate,
//         "package_name": packageName,
//         "price": price,
//         "order_id": orderId,
//         "status": status,
//       };
// }

class PurchageHistoryModel {
  PurchageHistoryModel({
    this.error,
    this.msg,
    this.result,
  });

  bool error;
  String msg;
  List<Result> result;

  factory PurchageHistoryModel.fromJson(Map<String, dynamic> json) =>
      PurchageHistoryModel(
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
    this.purchaseDate,
    this.packageName,
    this.price,
    this.orderId,
    this.status,
  });

  String purchaseDate;
  String packageName;
  String price;
  String orderId;
  String status;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        purchaseDate:
            json["purchase_date"] == null ? null : json["purchase_date"],
        packageName: json["package_name"] == null ? null : json["package_name"],
        price: json["price"] == null ? null : json["price"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "purchase_date": purchaseDate == null ? null : purchaseDate,
        "package_name": packageName == null ? null : packageName,
        "price": price == null ? null : price,
        "order_id": orderId == null ? null : orderId,
        "status": status == null ? null : status,
      };
}
