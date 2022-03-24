import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterbuyandsell/vender_models/my_listings_model.dart';
import 'package:http/http.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterbuyandsell/ui/vender_screens/edit_listing.dart';
import 'package:lottie/lottie.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutter/cupertino.dart';

import 'dart:convert';

import 'package:dio/dio.dart';

class MyListing extends StatefulWidget {
  const MyListing({Key key}) : super(key: key);

  @override
  _MyListingState createState() => _MyListingState();
}

class _MyListingState extends State<MyListing> {
  Color primaryColor = PsColors.mainColor;

  Future loadListing;
  List<MyListingModel> myListingModelList;
  List<Result> resultList;
  String listCount;
  List<MyListingModel> myListingModelFromJson(String str) =>
      List<MyListingModel>.from(
          json.decode(str).map((dynamic x) => MyListingModel.fromJson(x)));

  Future _loadListing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = await prefs.getString('vender_user_id');
    String user_name = await prefs.getString('vender_user_name');
    String user_email = await prefs.getString('vender_user_email');

    String user_phone = await prefs.getString('vender_user_phone');
    var response = await post(
      Uri.parse('https://deals24.live/Dealsjson/My_listings'),
      body: {'user_id': user_id},
    ).catchError((dynamic e) {
      print(e);
    });
    try {
      myListingModelList = myListingModelFromJson(response.body);

      if (myListingModelList[0].result != null) {
        setState(() {
          resultList = myListingModelList[0].result;
          listCount = resultList.length.toString();
        });
      } else {
        resultList = null;
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Widget _showLoader(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
            child: Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 5,
                child: Lottie.asset("assets/images/loader.json")));
      },
    );
  }

  Future _handleDelete(String listingId) async {
    _showLoader(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = await prefs.getString('vender_user_id');
    var response = await post(
      Uri.parse('https://deals24.live/Dealsjson/listing_delete'),
      body: {'user_id': user_id, 'listing_id': listingId},
    ).catchError((dynamic e) {
      print(e);
    });
    try {
      if (response.statusCode == 200) {
        dynamic responseBody = json.decode(response.body);
        Navigator.pop(context);
        showToast(responseBody[0]['msg'],
            context: context,
            animation: StyledToastAnimation.slideFromBottom,
            reverseAnimation: StyledToastAnimation.slideToBottom,
            startOffset: Offset(0.0, 3.0),
            reverseEndOffset: Offset(0.0, 3.0),
            position: StyledToastPosition.center,
            duration: Duration(seconds: 4),
            //Animation duration   animDuration * 2 <= duration
            animDuration: Duration(seconds: 1),
            curve: Curves.elasticOut,
            reverseCurve: Curves.fastOutSlowIn);

        setState(() {
          loadListing = _loadListing();
        });
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
      loadListing = _loadListing();
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
                              'My listing : ${listCount != null ? listCount : '0'}',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 250,
                            height: 50),
                        Container(
                            child: const Center(
                                child: Text(
                              'Date Added',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 200,
                            height: 50),
                        Container(
                            child: const Center(
                                child: Text(
                              'Actions ',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 180,
                            height: 50),
                      ],
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height - 200,
                        width: 630,
                        alignment: Alignment.topLeft,
                        child: FutureBuilder<dynamic>(
                            future: loadListing,
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
                                if (resultList != null) {
                                  print('not null');
                                  return ListView.builder(
                                    itemCount: resultList != null
                                        ? resultList.length
                                        : 0,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 250,
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                color: Colors.white,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Image.network(
                                                            resultList[index]
                                                                ?.image,
                                                            height: 50,
                                                            width: 50),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                              resultList[index]
                                                                  ?.title,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SizedBox(
                                                            width: 150,
                                                            child: Text(
                                                              resultList[index]
                                                                  ?.location,
                                                              style:
                                                                  TextStyle(),
                                                              softWrap: true,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 200,
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                color: Colors.grey[200],
                                                child: Center(
                                                    child: Text(
                                                        resultList[index]
                                                            ?.dateAdded)),
                                              ),
                                              Container(
                                                  width: 180,
                                                  height: 50,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  color: Colors.white,
                                                  child: Center(
                                                      child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute<
                                                                        Widget>(
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                              return EditListing(
                                                                  resultList[
                                                                          index]
                                                                      .listingId);
                                                            }));
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      primaryColor),
                                                          child: Text('Edit')),
                                                      IconButton(
                                                          onPressed: () {
                                                            _handleDelete(
                                                                resultList[
                                                                        index]
                                                                    .listingId);
                                                          },
                                                          color: Colors.red,
                                                          icon: Icon(
                                                              Icons.delete)),
                                                    ],
                                                  )))
                                            ]),
                                      );
                                    },
                                  );
                                } else {
                                  print('null lisitng');
                                  return Center(
                                    child: Container(
                                      child: Text('My Listing is Empty',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  );
                                }
                              }
                            }))
                  ],
                ))));
  }
}
