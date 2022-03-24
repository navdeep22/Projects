import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/add_on_model.dart';
import 'package:club_app/logic/models/cart_table_event_model.dart';
import 'package:club_app/logic/models/cart_table_event_model.dart';
import 'package:club_app/logic/models/tables_model.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AddOnState { Busy, NoData, ListRetrieved }

class AddOnsBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();
  BehaviorSubject<AddOnState> addOnListController =
      BehaviorSubject<AddOnState>();
  BehaviorSubject<AddOnState> tableCartsController =
      BehaviorSubject<AddOnState>();
  List<AddOnModel> addOnList;
  // List<TableModel> tableCarts = <TableModel>[];
  List<TableCartModel> tableCart = <TableCartModel>[];
  List<EventCartModel> eventCart = <EventCartModel>[];
  double totalPrice = 0.0;

  void dispose() {
    loaderController.close();
    addOnListController.close();
  }

  void fetchAddOns() {
    loaderController.add(true);
    _repository.fetchAddOnList().then((Response response) {
      loaderController.add(false);
      AddOnResponse addOnResponse =
          AddOnResponse.fromJson(json.decode(response.body));
      debugPrint('Add on api response is ===============>  ' + response.body);
      if (addOnResponse.status) {
        debugPrint(
            'Add on ID >>>> ' + addOnResponse.addOnModelList[0].id.toString());

        if (addOnResponse.addOnModelList != null ||
            addOnResponse.addOnModelList.isNotEmpty) {
          addOnList = addOnResponse.addOnModelList;
          print(addOnList.length);
          addOnListController.add(AddOnState.ListRetrieved);
        } else {
          addOnListController.add(AddOnState.NoData);
        }
      } else {
        addOnListController.add(AddOnState.NoData);
      }
    }).catchError((Object error) {
      loaderController.add(false);
    });
  }

  Future<void> fetchTableCartList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    loaderController.add(true);
    _repository.fetchTableCartList(userId.toString()).then((Response response) {
      loaderController.add(false);
      // print("fetchtable cart response --------- ${response.body}");
      CartTableEventResponse tableCartResponse =
          CartTableEventResponse.fromJson(json.decode(response.body));
      debugPrint('Table cart api response issss ==> ' + response.body);

      print(tableCartResponse.status);
      print(tableCartResponse.data.tables);
      print(tableCartResponse.data.events);
      if (tableCartResponse.status) {
        print("COMING HERE");
        if (tableCartResponse.data.tables != null &&
            tableCartResponse.data.events != null) {
          print("both have data");
          tableCart = tableCartResponse.data.tables;
          eventCart = tableCartResponse.data.events;
          print(tableCart[0].addons.length);
          print(tableCart[0].addons[0].createdAt);
        } else if (tableCartResponse.data.tables != null &&
            tableCartResponse.data.events == null) {
          print("tables");
          tableCart = tableCartResponse.data.tables;
        } else if (tableCartResponse.data.events != null &&
            tableCartResponse.data.tables == null) {
          print("events");
          eventCart = tableCartResponse.data.events;
        } else {
          eventCart = [];
          tableCart = [];
          print("here in else");
        }
      }
    }).catchError((Object error) {
      loaderController.add(false);
    });
  }

  Future<void> deleteTable(int tableId, BuildContext context) async {
    loaderController.add(true);
    _repository.deleteTablefromCart(tableId).then((Response response) async {
      loaderController.add(false);
      debugPrint(
          '--------delete table from cart response------ ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        fetchTableCartList();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint(
          'delete table from cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> deleteAddon(int addonCartId, BuildContext context) async {
    loaderController.add(true);
    _repository
        .deleteAddonfromCart(addonCartId)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint(
          '--------delete addon from cart response------ ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        fetchTableCartList();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint(
          'delete addon from cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> deleteEvent(int eventId, BuildContext context) async {
    loaderController.add(true);
    _repository.deleteEventfromCart(eventId).then((Response response) async {
      loaderController.add(false);
      debugPrint(
          '--------delete event from cart response------ ${response.body}');
      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        fetchTableCartList();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint(
          'delete event from cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
