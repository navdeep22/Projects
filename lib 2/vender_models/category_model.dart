class CategoryModel {
  CategoryModel({
    this.error,
    this.msg,
    this.categoryList,
  });

  bool error;
  String msg;
  List<CategoryListModel> categoryList;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        error: json["error"] == null ? null : json["error"],
        msg: json["msg"] == null ? null : json["msg"],
        categoryList: json["result"] == null
            ? null
            : List<CategoryListModel>.from(json["result"]
                .map((dynamic x) => CategoryListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "error": error == null ? null : error,
        "msg": msg == null ? null : msg,
        "result": categoryList == null
            ? null
            : List<dynamic>.from(categoryList.map<dynamic>((x) => x.toJson())),
      };
}

class CategoryListModel {
  CategoryListModel({
    this.categoryId,
    this.categoryName,
  });

  String categoryId;
  String categoryName;

  factory CategoryListModel.fromJson(Map<String, dynamic> json) =>
      CategoryListModel(
        categoryId: json["category_id"] == null ? null : json["category_id"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "category_id": categoryId == null ? null : categoryId,
        "category_name": categoryName == null ? null : categoryName,
      };
}
