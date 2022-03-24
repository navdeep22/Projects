class Listing {
  Listing({
    this.listingId,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.title,
    this.description,
    this.category,
    this.subcategory,
    this.city,
    this.location,
    this.price,
    this.images,
    this.error,
    this.msg,
  });

  String listingId;
  String userName;
  String userEmail;
  String userPhone;
  String title;
  String description;
  String category;
  String subcategory;
  String city;
  String location;
  String price;
  String images;
  bool error;
  String msg;

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        listingId: json["listing_id"] == null ? null : json["listing_id"],
        userName: json["user_name"] == null ? null : json["user_name"],
        userEmail: json["user_email"] == null ? null : json["user_email"],
        userPhone: json["user_phone"] == null ? null : json["user_phone"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        category: json["category"] == null ? null : json["category"],
        subcategory: json["subcategory"] == null ? null : json["subcategory"],
        city: json["city"] == null ? null : json["city"],
        location: json["location"] == null ? null : json["location"],
        price: json["price"] == null ? null : json["price"],
        images: json["images"] == null ? null : json["images"],
        error: json["error"] == null ? null : json["error"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "listing_id": listingId == null ? null : listingId,
        "user_name": userName == null ? null : userName,
        "user_email": userEmail == null ? null : userEmail,
        "user_phone": userPhone == null ? null : userPhone,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "category": category == null ? null : category,
        "subcategory": subcategory == null ? null : subcategory,
        "city": city == null ? null : city,
        "location": location == null ? null : location,
        "price": price == null ? null : price,
        "images": images == null ? null : images,
        "error": error == null ? null : error,
        "msg": msg == null ? null : msg,
      };
}
