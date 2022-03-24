import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterbuyandsell/vender_models/purchase_history_model.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:dio/dio.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({Key key}) : super(key: key);

  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  Future loadPurchaseHistory;
  List<PurchageHistoryModel> purchaseHistoryModelList;
  List<Result> purchaseHistoryList;

  List<PurchageHistoryModel> purchageHistoryFromJson(String str) =>
      List<PurchageHistoryModel>.from(json
          .decode(str)
          .map((dynamic x) => PurchageHistoryModel.fromJson(x)));

  Future _loadPurchaseHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = await prefs.getString('vender_user_id');
    String user_name = await prefs.getString('vender_user_name');
    String user_email = await prefs.getString('vender_user_email');

    String user_phone = await prefs.getString('vender_user_phone');
    print(user_id);
    var response = await post(
      Uri.parse('https://deals24.live/Dealsjson/package_purchase_history'),
      body: {'user_id': user_id},
    ).catchError((dynamic e) {
      print(e);
    });

    try {
      print(response.statusCode);
      if (response.statusCode == 200) {
        purchaseHistoryModelList = purchageHistoryFromJson(response.body);
        if (purchaseHistoryModelList[0].result != null) {
          setState(() {
            purchaseHistoryList = purchaseHistoryModelList[0].result;
          });
        } else {
          purchaseHistoryList = null;
        }
      } else {
        print('Error in Api Call');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loadPurchaseHistory = _loadPurchaseHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            child: Center(
                                child: Text(
                              'Purchase Date',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 200,
                            height: 50),
                        Container(
                            child: const Center(
                                child: Text(
                              'Package Name',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 200,
                            height: 50),
                        Container(
                            child: const Center(
                                child: Text(
                              'Price ',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 200,
                            height: 50),
                        Container(
                            child: const Center(
                                child: Text(
                              'Order id ',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 200,
                            height: 50),
                        Container(
                            child: const Center(
                                child: Text(
                              'Status',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 200,
                            height: 50),
                      ],
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height - 200,
                        width: 1000,
                        alignment: Alignment.topLeft,
                        child: FutureBuilder<dynamic>(
                            future: loadPurchaseHistory,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 200, vertical: 200),
                                    child: const CupertinoActivityIndicator(
                                      radius: 30,
                                      animating: true,
                                    ));
                              } else {
                                if (purchaseHistoryList != null) {
                                  return ListView.builder(
                                    itemCount: purchaseHistoryList?.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 200,
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                color: Colors.white,
                                                child: Center(
                                                    child: Text(
                                                        purchaseHistoryList[
                                                                index]
                                                            .purchaseDate)),
                                              ),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                color: Colors.grey[200],
                                                child: Center(
                                                    child: Text(
                                                        purchaseHistoryList[
                                                                index]
                                                            .packageName)),
                                              ),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                color: Colors.white,
                                                child: Center(
                                                    child: Text(
                                                        purchaseHistoryList[
                                                                index]
                                                            .price)),
                                              ),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                color: Colors.grey[200],
                                                child: Center(
                                                    child: Text(
                                                        purchaseHistoryList[
                                                                index]
                                                            .orderId)),
                                              ),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                color: Colors.white,
                                                child: Center(
                                                    child: Text(
                                                        purchaseHistoryList[
                                                                index]
                                                            .status)),
                                              ),
                                            ]),
                                      );
                                    },
                                  );
                                } else {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 100, vertical: 200),
                                    child: Text('Purchase History is Empty',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                  );
                                }
                              }
                            }))
                  ],
                ))));
  }
}
