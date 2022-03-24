import 'dart:convert';

import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

class GuestListBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();

  void dispose() {
    loaderController.close();
  }

  Future<void> guestListAdd(
      String name,
      String email,
      String phoneNumber,
      int menCount,
      int womenCount,
      String referenceName,
      BuildContext context) async {
    loaderController.add(true);
    _repository
        .updateGuestList(
            name, email, phoneNumber, menCount, womenCount, referenceName)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('Guest list update response is ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        Navigator.of(context).pop();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Guest list update response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });

  }
}
