import 'dart:async';
import 'package:flutterbuyandsell/vender_models/vender_detail_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterbuyandsell/ui/vender_screens/vender_dashboard.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  bool _isInit = true;
  String contact;

  OtpScreen({this.contact});
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  VenderUser venderUser;
  AnimationController _controller;
  Color primaryColor = PsColors.mainColor;

  final TextEditingController smsController = TextEditingController();
  final smsValidator = MultiValidator([
    MaxLengthValidator(6, errorText: 'Please enter a valid OTP'),
    MinLengthValidator(6, errorText: 'Please enter a valid OTP')
  ]);

  bool _buttonDisabled = true;
  String _verificationCode = '';

  // Variables
  Size _screenSize;

  bool isValid = false;

  bool _isRefreshing = false;
  bool _codeTimedOut = false;
  bool _codeVerified = false;

  Future<Null> _updateRefreshing(bool isRefreshing) async {
    //print('Setting _isRefreshing ($_isRefreshing) to $isRefreshing');
    if (_isRefreshing) {
      setState(() {
        this._isRefreshing = false;
      });
    }
    setState(() {
      this._isRefreshing = isRefreshing;
    });
  }

  // Returns "Resend" button

  void clearOtp() {
    smsController.text = '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  //dispose controllers
  @override
  void dispose() {
    super.dispose();
  }

  void verifyOtp() async {
    if (smsController.text.length < 6) {
      FocusScope.of(context).unfocus();
      showToast('Please enter valid otp',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          startOffset: Offset(0.0, 3.0),
          reverseEndOffset: Offset(0.0, 3.0),
          position: StyledToastPosition.bottom,
          duration: Duration(seconds: 4),
          //Animation duration   animDuration * 2 <= duration
          animDuration: Duration(seconds: 1),
          curve: Curves.elasticOut,
          reverseCurve: Curves.fastOutSlowIn);
    } else {
      // Map<String, String> body = {'mobile': '9478412563'};
      // FormData formData = FormData.fromMap(body);
      var response = await post(
        Uri.parse('https://deals24.live/Dealsjson/userlogin_verifyOTP'),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        // },
        body: {'mobile': widget.contact, 'otp': smsController.text},
      ).catchError((dynamic e) {
        print(e);
      });
      try {
        print(response.statusCode);
        print(response.body);
        venderUser = VenderUser.fromJson(json.decode(response.body));
        // dynamic jsonResponse = await jsonDecode(response.body);
        if (venderUser.error == true) {
          print(venderUser.msg);
          print('false');
          showToast(venderUser.msg,
              context: context,
              animation: StyledToastAnimation.slideFromBottom,
              reverseAnimation: StyledToastAnimation.slideToBottom,
              startOffset: Offset(0.0, 3.0),
              reverseEndOffset: Offset(0.0, 3.0),
              position: StyledToastPosition.bottom,
              duration: Duration(seconds: 4),
              //Animation duration   animDuration * 2 <= duration
              animDuration: Duration(seconds: 1),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
        } else {
          print('true');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('loginAsVender', true);
          await prefs.setString('vender_user_id', venderUser.userId);
          await prefs.setString('vender_user_name', venderUser.userName);
          await prefs.setString('vender_user_email', venderUser.userEmail);
          await prefs.setString('vender_user_phone', venderUser.userPhone);

          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => const VenderDashboard()));
        }
      } catch (e) {
        Navigator.pop(context);
      }
    }
  }

  //build method for UI
  @override
  Widget build(BuildContext context) {
    //Getting screen height width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // title: const Text('Vender Login',
        //     style: TextStyle(color: Color(0xff711b23))),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Container(
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    'assets/images/flutter_buy_and_sell_logo.png',
                  ),
                ),
                // Image.network(
                //   'https://firebasestorage.googleapis.com/v0/b/shanthi-safebuy-admin.appspot.com/o/delivery%2F33547-otp-reveived-1.gif?alt=media&token=4129df05-ef8d-421e-970b-cde65062d72e',
                //   height: screenHeight * 0.25,
                //   fit: BoxFit.contain,
                // ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        child: const Text(
                      'Verification',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(27, 27, 27, 1),
                          fontSize: 26,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ))),
                const SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        child: Text(
                      'Please enter  6 digit number that was\n sent to +91 ${widget.contact}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color.fromRGBO(27, 27, 27, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          height: 1.5),
                    ))),
                SizedBox(
                  height: screenHeight * 0.05,
                ),

                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16),
                  padding: const EdgeInsets.all(16.0),

                  // ignore: prefer_const_literals_to_create_immutables

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: screenWidth * 0.025),
                        child: PinCodeTextField(
                          controller: smsController,
                          autoFocus: true,
                          appContext: context,
                          keyboardType: TextInputType.number,
                          length: 6,
                          showCursor: false,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              fieldHeight: 50,
                              fieldWidth: 40,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              inactiveColor: primaryColor.withOpacity(0.2),
                              activeColor: primaryColor.withOpacity(0.8),
                              selectedColor: primaryColor),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          onSubmitted: (text) => _updateRefreshing(true),
                          onChanged: (value) {
                            setState(() {
                              if (value.length == 6) {
                                _buttonDisabled = false;
                              } else {
                                _buttonDisabled = true;
                              }
                              _verificationCode = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            return false;
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      GestureDetector(
                        onTap: verifyOtp,
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor,
                          ),
                          child: const Center(
                            child: Text(
                              'Verify',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
