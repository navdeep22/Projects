import 'dart:async';

import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/create_payment_bloc.dart';
import 'package:club_app/logic/bloc/sign_up_bloc.dart';
import 'package:club_app/logic/bloc/stripe_keys_bloc.dart';
import 'package:club_app/payment.dart';
import 'package:club_app/ui/screens/landing.dart';
import 'package:club_app/ui/utils/card_formatter.dart';
import 'package:club_app/ui/utils/utility.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  double total;
  Checkout(this.total);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownValueforNationality = 'Indian';
  String dropdownValueforExpectedArrival = 'Not Sure';
  String dropdownValueforPayment = 'Select Payment Method';
  bool isChecked = false;
  TextEditingController _textcontroller = TextEditingController();

  SignUpBloc _signUpBloc;
  CheckOutBloc _checkOutBloc;

  @override
  void initState() {
    super.initState();
    _checkOutBloc = CheckOutBloc();
    _signUpBloc = SignUpBloc();
    handleProfileAPI();
    StripeService.init();
  }

  void payNow(BuildContext context) async {
    //the amount must be transformed to cents
    // var amount = widget.total.toString();
    String amount = widget.total.toString();
    String decimal = '0' + amount.substring(amount.indexOf('.'));
    String integer = amount.substring(0, amount.indexOf('.'));
    double Amount =
        (double.parse(integer) * 100) + (double.parse(decimal) * 100);
    var finalAmount = Amount.toInt();

    print("------------------amount---------------------$amount");
    print("------------------integer---------------------$integer");
    print("------------------decimal---------------------$decimal");
    print("------------------cents---------------------$finalAmount");

    var response = await StripeService.payNowHandler(
        amount: finalAmount.toString(), currency: 'USD');
    print('response message ${response.message}');
    print('${response.success}');
    print('response ${response.toString()}');
    if (response.success == true) {
      submitResponse(context, response.pid);
      Utility.showSnackBarMessage(_scaffoldKey, "Payment Successfull");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('public_key');
      prefs.remove('secret_key');
    }
  }

  void submitResponse(BuildContext context, String pid) async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt(ClubApp.userId);
      _checkOutBloc.completePayment(
          dropdownValueforExpectedArrival,
          _signUpBloc.nameController.text,
          "USD",
          _signUpBloc.emailController.text,
          widget.total.toString(),
          pid,
          _checkOutBloc.checkoutModel.data.orderId,
          _checkOutBloc.checkoutModel.data.guestId.toString(),
          userId.toString(),
          "succeeded",
          context);
    } else {
      ackAlert(context, ClubApp.no_internet_message);
    }
  }

  Future<void> handleProfileAPI() async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt(ClubApp.userId);
      _signUpBloc.getUserDetails(userId.toString(), context);
    } else {
      ackAlert(context, ClubApp.no_internet_message);
    }
  }

  @override
  void dispose() {
    // _checkOutBloc.dispose();
    _signUpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: Text('GO Back To Cart'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AppNavigator.gotoLanding(context);
            },
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(
                        Icons.verified_user_sharp,
                        color: Colors.green,
                      ),
                      Text(
                        " Proceed To Checkout",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ]),
                    Text(
                      "TOTAL : ${ClubApp.currencyLbl} ${widget.total}",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(height: 20),
                FittedBox(
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Already a member ? If you already have an account, simply Login and checkout quickly",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Your Name",
                        style: TextStyle(
                          color: Colors.white,
                        ))
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: TextFormField(
                        controller: _signUpBloc.nameController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.5),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.5),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Your Email",
                        style: TextStyle(
                          color: Colors.white,
                        ))
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: TextFormField(
                        controller: _signUpBloc.emailController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Your Email",
                          hintStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.5),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.5),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Nationality",
                        style: TextStyle(
                          color: Colors.white,
                        ))
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.05,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: appBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border: Border.all(color: Colors.white, width: 0.5),
                        ),
                        child: DropdownButton(
                          value: dropdownValueforNationality,
                          dropdownColor: Colors.grey.shade700,
                          isExpanded: true,
                          underline: Container(),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          style: TextStyle(color: Colors.white),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueforNationality = newValue;
                            });
                          },
                          items: <String>['Indian', 'Others']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Phone",
                        style: TextStyle(
                          color: Colors.white,
                        ))
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: TextFormField(
                        controller: _signUpBloc.mobileController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "Phone",
                          hintStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.5),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.5),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Expected Arrival",
                        style: TextStyle(
                          color: Colors.white,
                        ))
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.05,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: appBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border: Border.all(color: Colors.white, width: 0.5),
                        ),
                        child: DropdownButton(
                          value: dropdownValueforExpectedArrival,
                          dropdownColor: Colors.grey.shade700,
                          isExpanded: true,
                          underline: Container(),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          style: TextStyle(color: Colors.white),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueforExpectedArrival = newValue;
                            });
                          },
                          items: <String>[
                            'Not Sure',
                            '11 AM - 12 PM',
                            '12 PM - 01 PM',
                            '01 PM - 02 PM',
                            '02 PM - 03 PM'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Container(
                        child: Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                            activeColor: Colors.green,
                            side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    color: Colors.white, width: 0.5)),
                            value: isChecked,
                            onChanged: (bool value) {
                              // This is where we update the state when the checkbox is tapped
                              setState(() {
                                isChecked = value;
                                print(isChecked);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "  Create An Account ?",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Note : All package is non-refundable policy. In case of cancelled, modified or no-show, the total price of the reservation will be charged.",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 3,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                FittedBox(
                  child: Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.27,
                          child: Divider(
                            color: Colors.white,
                          )),
                      Text(
                        "  PROCEED TO PAYMENT  ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.27,
                          child: Divider(
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Text(
                //         "Payment Method (You can also pay via Credit Cards / other cards by selecting Paypal)",
                //         style: TextStyle(
                //           color: Colors.white,
                //         ),
                //         maxLines: 2,
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 10),
                // Row(
                //   children: [
                //     Container(
                //         width: MediaQuery.of(context).size.width * 0.90,
                //         height: MediaQuery.of(context).size.height * 0.05,
                //         padding: EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //           color: appBackgroundColor,
                //           borderRadius: BorderRadius.all(Radius.circular(25)),
                //           border: Border.all(color: Colors.white, width: 0.5),
                //         ),
                //         child: DropdownButton(
                //           value: dropdownValueforPayment,
                //           dropdownColor: Colors.grey.shade700,
                //           isExpanded: true,
                //           underline: Container(),
                //           icon: Icon(
                //             Icons.keyboard_arrow_down,
                //             color: Colors.white,
                //           ),
                //           style: TextStyle(color: Colors.white),
                //           onChanged: (String newValue) {
                //             setState(() {
                //               dropdownValueforPayment = newValue;
                //             });
                //           },
                //           items: <String>['Select Payment Method', 'Paypal']
                //               .map<DropdownMenuItem<String>>((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(value),
                //             );
                //           }).toList(),
                //         ))
                //   ],
                // ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineBorderButton(
                        buttonBackground,
                        12.0,
                        32.0,
                        ClubApp.btn_checkout,
                        Theme.of(context)
                            .textTheme
                            .subtitle1
                            .apply(color: Colors.white), onPressed: () async {
                      print("checkout button------------------");
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      int userId = prefs.getInt(ClubApp.userId);

                      _checkOutBloc.checkout(
                        userId.toString(),
                        _signUpBloc.nameController.text,
                        _signUpBloc.emailController.text,
                        _signUpBloc.mobileController.text,
                        widget.total.toString(),
                        dropdownValueforPayment,
                        context,
                      );
                      Timer(Duration(seconds: 2), () {
                        _checkOutBloc.statuss == true
                            ? payNow(context)
                            : ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                content: Text("Something went wrong"),
                              ));
                      });
                    }),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
