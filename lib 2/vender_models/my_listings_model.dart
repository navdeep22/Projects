// class MyListingModel {
//   MyListingModel({
//     this.error,
//     this.msg,
//     this.result,
//   });

//   bool error;
//   String msg;
//   List<Result> result;

//   factory MyListingModel.fromJson(Map<String, dynamic> json) => MyListingModel(
//         error: json["error"],
//         msg: json["msg"],
//         result: List<Result>.from(
//             json["result"].map((dynamic x) => Result.fromJson(x))),
//       );
// }

// class Result {
//   Result({
//     this.listingId,
//     this.image,
//     this.title,
//     this.location,
//     this.dateAdded,
//   });

//   String listingId;
//   String image;
//   String title;
//   String location;
//   String dateAdded;

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         listingId: json["listing_id"],
//         image: json["image"],
//         title: json["title"],
//         location: json["location"],
//         dateAdded: json["date_added"],
//       );
// }

class MyListingModel {
  MyListingModel({
    this.error,
    this.msg,
    this.result,
  });

  bool error;
  String msg;
  List<Result> result;

  factory MyListingModel.fromJson(Map<String, dynamic> json) => MyListingModel(
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
    this.listingId,
    this.image,
    this.title,
    this.location,
    this.dateAdded,
  });

  String listingId;
  String image;
  String title;
  String location;
  String dateAdded;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        listingId: json["listing_id"] == null ? null : json["listing_id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        location: json["location"] == null ? null : json["location"],
        dateAdded: json["date_added"] == null ? null : json["date_added"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "listing_id": listingId == null ? null : listingId,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "location": location == null ? null : location,
        "date_added": dateAdded == null ? null : dateAdded,
      };
}
