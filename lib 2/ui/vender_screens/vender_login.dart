import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:path/path.dart';
import 'package:flutterbuyandsell/ui/vender_screens/vender_otp.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';

class VenderLogin extends StatefulWidget {
  @override
  _VenderLoginState createState() => _VenderLoginState();
}

class _VenderLoginState extends State<VenderLogin> {
  final _contactEditingController = TextEditingController();
  Color primaryColor = PsColors.mainColor;
  var _dialCode = '';

  final phoneNoValidator = MultiValidator([
    MinLengthValidator(10, errorText: 'Please enter a valid phone number'),
    MaxLengthValidator(10, errorText: 'Please enter a valid phone number'),
    RequiredValidator(errorText: 'This field is required'),
    PatternValidator(r'(0/91)?[6-9][0-9]{9}',
        errorText: 'Please enter a valid phone number')
  ]);

  //Login click with contact number validation
  Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty ||
        _contactEditingController.text.length < 10) {
      showToast('Please Enter a valid mobile number...',
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
      Map<String, String> body = {'mobile': '9478412563'};
      FormData formData = FormData.fromMap(body);
      var response = await post(
        Uri.parse('https://deals24.live/Dealsjson/userlogin'),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        // },
        body: {'mobile': _contactEditingController.text},
      ).catchError((dynamic e) {
        print(e);
      });
      try {
        print(response.statusCode);
        print(response.body);
        dynamic jsonResponse = await jsonDecode(response.body);
        if (jsonResponse['error'] == true) {
          print(jsonResponse);
          showToast(jsonResponse['msg'],
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
          print(jsonResponse);
          showToast('Otp sent successfully',
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
          // Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      OtpScreen(contact: _contactEditingController.text)));
        }
      } catch (e) {
        Navigator.pop(context);
      }
    }
  }

  //build method for UI Representation
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Vender Login', style: TextStyle(color: primaryColor)),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // ignore: always_specify_types
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // Image.asset(
                    //   'assets/images/logo.png',
                    //   width: 250,
                    //   fit: BoxFit.contain,
                    // ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                        'assets/images/flutter_buy_and_sell_logo.png',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            child: Text(
                          'Login to your Vender account',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        ))),
                    const SizedBox(
                      height: 15,
                    ),

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color.fromARGB(255, 253, 188, 51),
                              ),
                              // borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  '+91',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                Expanded(
                                  child: TextField(
                                    maxLength: 10,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Mobile  Number',
                                      counterText: '',
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 13.5),
                                    ),
                                    controller: _contactEditingController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (value) {
                                      if (value.length == 10) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _showSendOTP(context)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _showSendOTP(BuildContext context) {
    final GestureDetector loginButtonWithGesture = GestureDetector(
      onTap: () => clickOnLogin(context),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(10)),
        child: const Center(
          child: Text(
            'Send OTP',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(
            left: 0.0, right: 0.0, top: 15.0, bottom: 30.0),
        child: loginButtonWithGesture);
  }
}
