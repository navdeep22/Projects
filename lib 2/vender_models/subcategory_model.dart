class SubCategoryModel {
  SubCategoryModel({
    this.error,
    this.msg,
    this.subCategoryList,
  });

  bool error;
  String msg;
  List<SubCategoryListModel> subCategoryList;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        error: json["error"] == null ? null : json["error"],
        msg: json["msg"] == null ? null : json["msg"],
        subCategoryList: json["result"] == null
            ? null
            : List<SubCategoryListModel>.from(json["result"]
                .map((dynamic x) => SubCategoryListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "error": error == null ? null : error,
        "msg": msg == null ? null : msg,
        "result": subCategoryList == null
            ? null
            : List<dynamic>.from(
                subCategoryList.map<dynamic>((x) => x.toJson())),
      };
}

class SubCategoryListModel {
  SubCategoryListModel({
    this.subcategoryId,
    this.subcategoryName,
  });

  String subcategoryId;
  String subcategoryName;

  factory SubCategoryListModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryListModel(
        subcategoryId:
            json["subcategory_id"] == null ? null : json["subcategory_id"],
        subcategoryName:
            json["subcategory_name"] == null ? null : json["subcategory_name"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "subcategory_id": subcategoryId == null ? null : subcategoryId,
        "subcategory_name": subcategoryName == null ? null : subcategoryName,
      };
}
