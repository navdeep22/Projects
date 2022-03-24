import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterbuyandsell/vender_models/package_model.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/cupertino.dart';

class Packages extends StatefulWidget {
  const Packages({Key key}) : super(key: key);

  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  Future loadPackages;
  Razorpay razorpay;
  String orderId;
  List<PackageClass> packageClassModelList;
  List<Result> packageList;

  List<PackageClass> packageClassFromJson(String str) =>
      List<PackageClass>.from(
          json.decode(str).map((dynamic x) => PackageClass.fromJson(x)));

  Future _loadPackages() async {
    var response = await post(
      Uri.parse('https://deals24.live/Dealsjson/packages'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: {'user_id': 'usrfef01a55a404e5b1b772d1d06a7efb3c'},
    ).catchError((dynamic e) {
      print(e);
    });
    try {
      print(response.statusCode);
      packageClassModelList = packageClassFromJson(response.body);
      if (packageClassModelList[0].result != null) {
        setState(() {
          packageList = packageClassModelList[0].result;
        });
        print(packageList);
      } else {
        packageList = null;
      }
    } catch (e) {
      print(e.message);
    }
  }

  void openCheckout(String id, String price) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = await prefs.getString('vender_user_id');

    var response = await post(
      Uri.parse('https://deals24.live/Dealsjson/package_purchase_order_id'),
      body: {'user_id': user_id, 'package_id': id},
    ).catchError((dynamic e) {
      print(e);
    });
    try {
      if (response.statusCode == 200) {
        dynamic responseBody = await json.decode(response.body);
        orderId = await responseBody[0]['order_id'].toString();
      }
    } catch (e) {
      print(e);
    }

    print('ordrid$orderId');

    var options = {
      "key": "rzp_test_yn0oSGGQ0oNYYv",
      "amount": num.parse(price) * 100,
      "name": "Deals24",
      "currency": "INR",
      "receipt": "rcptid_11",
      // "order_id": orderId,
      "description": "Payment for the some random product",
      "prefill": {"contact": "2323232323", "email": "shdjsdh@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      await razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse paymentResponse) async {
    print(paymentResponse.paymentId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = await prefs.getString('vender_user_id');

    var response = await post(
      Uri.parse('https://deals24.live/Dealsjson/purchase_package'),
      body: {'user_id': user_id, 'order_id': orderId, 'status': '2'},
    ).catchError((dynamic e) {
      print(e);
    });
    try {
      if (response.statusCode == 200) {
        setState(() {
          loadPackages = _loadPackages();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void handlerErrorFailure() async {
    print("Pament error");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = await prefs.getString('vender_user_id');

    var response = await post(
      Uri.parse('https://deals24.live/Dealsjson/purchase_package'),
      body: {'user_id': user_id, 'order_id': orderId, 'status': '1'},
    ).catchError((dynamic e) {
      print(e);
    });
    try {
      if (response.statusCode == 200) {
        setState(() {
          loadPackages = _loadPackages();
        });
      }
    } catch (e) {
      print(e);
    }
    // Toast.show("Pament error", context);
  }

  void handlerExternalWallet() {
    print("External Wallet");
    // Toast.show("External Wallet", context);
  }

  @override
  void initState() {
    // TODO: implement initState
    //rzp_test_yn0oSGGQ0oNYYv
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    setState(() {
      loadPackages = _loadPackages();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
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
                              'Package : ${packageList != null ? packageList.length : '0'} ',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 200,
                            height: 50),
                        Container(
                            child: const Center(
                                child: Text(
                              'Duration',
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
                              'Description ',
                              style: TextStyle(fontSize: 18),
                            )),
                            color: Colors.brown[100],
                            width: 200,
                            height: 50),
                        Container(
                            child: const Center(
                                child: Text(
                              'Buy Now ',
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
                          future: loadPackages,
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
                              if (packageList != null) {
                                return ListView.builder(
                                  itemCount: packageList?.length,
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
                                                  child: Text(packageList[index]
                                                      .packageName)),
                                            ),
                                            Container(
                                              width: 200,
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              color: Colors.grey[200],
                                              child: Center(
                                                  child: Text(packageList[index]
                                                      .duration)),
                                            ),
                                            Container(
                                              width: 200,
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              color: Colors.white,
                                              child: Center(
                                                  child: Text(packageList[index]
                                                      .price)),
                                            ),
                                            Container(
                                              width: 200,
                                              height: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              color: Colors.grey[200],
                                              child: Center(
                                                  child: Text(packageList[index]
                                                      .description)),
                                            ),
                                            Container(
                                                width: 200,
                                                height: 50,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                color: Colors.white,
                                                child: packageList[index]
                                                            .purchaseStatus ==
                                                        'buy now'
                                                    ? TextButton(
                                                        onPressed: () {
                                                          openCheckout(
                                                              packageList[index]
                                                                  .packageId,
                                                              packageList[index]
                                                                  .price);
                                                        },
                                                        child: Text('Buy Now'))
                                                    : Container(
                                                        child: Center(
                                                            child: Text(
                                                                'Purchased')))),
                                          ]),
                                    );
                                  },
                                );
                              } else {
                                print('null lisitng');
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 150, vertical: 200),
                                  child: Text('No Packages',
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                );
                              }
                            }
                          },
                        ))
                  ],
                ))));
  }

  void _showToast(String msg) {
    showToast(msg,
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
  }
}
