class VenderUser {
  VenderUser({
    this.userId,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.error,
    this.msg,
  });

  String userId;
  String userName;
  String userEmail;
  String userPhone;
  bool error;
  String msg;

  factory VenderUser.fromJson(Map<String, dynamic> json) => VenderUser(
        userId: json["user_id"] == null ? null : json["user_id"],
        userName: json["user_name"] == null ? null : json["user_name"],
        userEmail: json["user_email"] == null ? null : json["user_email"],
        userPhone: json["user_phone"] == null ? null : json["user_phone"],
        error: json["error"] == null ? null : json["error"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "user_id": userId == null ? null : userId,
        "user_name": userName == null ? null : userName,
        "user_email": userEmail == null ? null : userEmail,
        "user_phone": userPhone == null ? null : userPhone,
        "error": error == null ? null : error,
        "msg": msg == null ? null : msg,
      };
}
