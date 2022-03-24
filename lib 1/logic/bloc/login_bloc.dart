import 'dart:async';
import 'dart:convert';

import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/event_model.dart';
import 'package:club_app/logic/models/login.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> rememberMeController = BehaviorSubject<bool>();
  BehaviorSubject<bool> visibleController = BehaviorSubject<bool>();
  BehaviorSubject<bool> autoValidateController = BehaviorSubject<bool>();

  Stream<bool> get rememberMeStream => rememberMeController.stream;

  Stream<bool> get visibleStream => visibleController.stream;
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();

  void dispose() {
    rememberMeController.close();
    visibleController.close();
    autoValidateController.close();
    loaderController.close();
  }

  Future<void> loginUser(String username, String password, String type,
      EventModel eventModel, BuildContext context) async {
    print(type);
    loaderController.add(true);
    _repository.loginUser(username, password).then((Response response) async {
      loaderController.add(false);
      debugPrint('Login response is ${response.body}');
      LoginResponse loginResponse =
          LoginResponse.fromJson(json.decode(response.body));
      if (loginResponse.status) {
        await _saveUserDetailsToSharedPref(loginResponse.userDetails);
        if (type == "event") {
          AppNavigator.gotoBookEvent(context, eventModel);
        } else if (type == "table" || type == "sidemenu" || type == "cart") {
          AppNavigator.gotoLanding(context);
        } else if (type == "enddrawer") {
          AppNavigator.gotoBookings(context);
        }
      } else {
        ackAlert(context, loginResponse.error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Login response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> forgetPassword(String email, BuildContext context) async {
    loaderController.add(true);
    _repository.forgetPassword(email).then((Response response) async {
      loaderController.add(false);
      debugPrint('Forget password response is ${response.body}');
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status']) {
        ackAlert(context,
            'Password has be sent successfully to registered email address');
      } else {
        debugPrint('Forget password failed with message ${map['error']}');
        ackAlert(context, map['error']);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Forget pasword response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> loginGoogleUser(String email, String firstName, String lastName,
      BuildContext context) async {
    loaderController.add(true);
    _repository
        .loginGoogleUser(email, firstName, lastName)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('Google Login response is ${response.body}');
      LoginResponse loginResponse =
          LoginResponse.fromJson(json.decode(response.body));
      if (loginResponse.status) {
        await _saveUserDetailsToSharedPref(loginResponse.userDetails);
        AppNavigator.gotoLanding(context);
      } else {
        ackAlert(context, loginResponse.error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Login response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> _saveUserDetailsToSharedPref(UserDetails userDetails) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(ClubApp.loginSuccess, true);
      prefs.setInt(ClubApp.userId, userDetails.userId);
      prefs.setString(ClubApp.firstName, userDetails.firstName);
      prefs.setString(ClubApp.lastName, userDetails.lastName);
      prefs.setInt(ClubApp.gender, userDetails.gender);
      prefs.setString(ClubApp.phone, userDetails.phone);
      prefs.setString(ClubApp.email, userDetails.email);
      prefs.setInt(ClubApp.status, userDetails.status);
    } catch (e) {
      print(e);
    }
  }
}
