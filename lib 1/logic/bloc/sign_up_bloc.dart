import 'dart:convert';

import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/observer/user_profile_observable.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController residenceController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int _genderValue = -1;
  bool isEnabled = true;

  int get genderValue => _genderValue;
  void set genderValue(int value) => _genderValue = value;

  void dispose() {
    loaderController.close();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dobController.dispose();
    addressController.dispose();
    mobileController.dispose();
    residenceController.dispose();
  }

  Future<void> registerUser(
      String name,
      String email,
      String password,
      String confirmPassword,
      String phone,
      String gender,
      BuildContext context) async {
    loaderController.add(true);
    _repository
        .signUpUser(name, email, password, confirmPassword, gender, phone)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('Sign Up response is ${response.body}');

      /// Yet to parse sign up api as response format is not fixed
      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        //AppNavigator.gotoLogin(context);
        ackAlertWithBackScreen(context, ClubApp.register_success_message);
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Sign up response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
    ;
  }

  Future<void> getUserDetails(String userId, BuildContext context) async {
    loaderController.add(true);
    _repository.getUserProfile(userId).then((Response response) {
      debugPrint('User rofile api response is ${response.body}');
      Map map = json.decode(response.body);
      if (map['status'] as bool) {
        nameController.text =
            map['data']['first_name'] + ' ' + map['data']['last_name'];
        emailController.text = map['data']['email'];
        mobileController.text = map['data']['phone'];
        residenceController.text = map['data']['nationality'];
        genderValue = map['data']['gender'];
        print("-----name----- ${nameController.text}");
        if (mobileController.text.isEmpty) {
          isEnabled = true;
        } else {
          isEnabled = false;
        }
      }

      loaderController.add(false);
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('User Profile response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> updateUserDetails(
      String userId,
      String name,
      String gender,
      String nationality,
      String phone,
      String email,
      BuildContext context) async {
    loaderController.add(true);
    _repository
        .updateUserProfile(userId, name, gender, nationality, phone, email)
        .then((Response response) async {
      debugPrint('Update User rofile api response is ${response.body}');
      Map map = json.decode(response.body);
      loaderController.add(false);
      if (map['status'] as bool) {
        String firstName = name;
        String lastName = name;
        List<String> nameArray = name.split(' ');
        if (nameArray.length > 1) {
          firstName = nameArray[0];
          lastName = '';
          for (int i = 1; i < nameArray.length; i++) {
            lastName = lastName + ' ' + nameArray[i];
          }
        }

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(ClubApp.firstName, firstName);
        prefs.setString(ClubApp.lastName, lastName);
        prefs.setInt(ClubApp.gender, gender == 'Male' ? 1 : 2);
        prefs.setString(ClubApp.phone, phone);
        UserProfileObservable userProfileObservable = UserProfileObservable();
        userProfileObservable.notifyUpdateUserName(name);
        ackAlertWithBackScreen(context, map['error']);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('User Profile response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
