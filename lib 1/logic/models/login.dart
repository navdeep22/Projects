class LoginResponse {
  LoginResponse.fromJson(Map jsonMap) {
    status = jsonMap['status'];
    error = jsonMap['error'];
    if(jsonMap['data'] != null) {
      userDetails = UserDetails.fromJson(jsonMap['data']);
    }
  }

  bool status;
  String error;
  UserDetails userDetails;
}

class UserDetails {
  UserDetails();

  UserDetails.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
//    nationality = json['nationality'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
  }

  int userId;
  String firstName;
  String lastName;
//  String nationality;
  int gender;
  String phone;
  String email;
  int status;
}
