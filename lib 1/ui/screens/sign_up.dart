import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/constants/validator.dart';
import 'package:club_app/logic/bloc/sign_up_bloc.dart';
import 'package:club_app/ui/screens/login.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/button_rounded_border.dart';
import 'package:club_app/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int _genderValue = -1;
  SignUpBloc _signUpBloc;

  @override
  void initState() {
    super.initState();
    _signUpBloc = SignUpBloc();
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget getAppLogo() {
      return Container(
        child: Image.asset(
          'assets/images/ic_launcher.png',
//          color: Colors.white,
//          fit: BoxFit.fill,
          width: 100,
          // height: 60,
        ),
      );
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          helpText: ClubApp.hint_dob,
          initialDate: selectedDate,
          firstDate: DateTime(1950),
          lastDate: DateTime.now());
      if (picked != null && picked != selectedDate)
        setState(() {
          final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
          final String formatDate = dateFormat.format(picked);
          dobController.text = formatDate;
          selectedDate = picked;
        });
    }

    Widget cardSignUp() {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  getAppLogo(),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    nameController,
                    _autoValidate,
                    TextInputType.text,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_name,
                    validator: (String text) {
                      if (text == '' && text.isEmpty) {
                        return ClubApp.name_empty_msg;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    emailController,
                    _autoValidate,
                    TextInputType.emailAddress,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_email,
                    validator: (String text) {
                      return Validator.validateEmail(text);
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    passwordController,
                    _autoValidate,
                    TextInputType.text,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_password,
                    obscureText: true,
                    validator: (String text) {
                      if (text == '' && text.isEmpty) {
                        return ClubApp.password_empty_msg;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    confirmPasswordController,
                    _autoValidate,
                    TextInputType.text,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_confirm_password,
                    validator: (String text) {
                      if (text == '' && text.isEmpty) {
                        return ClubApp.confirm_password_empty_msg;
                      } else if (text.trim() !=
                          passwordController.text.trim()) {
                        return ClubApp.password_un_match_msg;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  /*InkWell(
                    onTap: () {
                      _selectDate(
                          context); // Call Function that has showDatePicker()
                    },
                    child: IgnorePointer(
                      child: CustomTextField(
                        dobController,
                        _autoValidate,
                        TextInputType.text,
                        Theme.of(context)
                            .textTheme
                            .bodyText2
                            .apply(color: colorPrimaryText),
                        ClubApp.hint_dob,
                        validator: (String text) {
                          if (text == '' && text.isEmpty) {
                            return ClubApp.dob_empty_msg;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),*/
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      ClubApp.hint_gender,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .apply(color: colorPrimaryText),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Theme(
                      data: ThemeData.dark(),
                      //set the dark theme or write your own theme
                      child: Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: _genderValue,
                            onChanged: _handleGenderChanged,
                            activeColor: colorPrimaryText,
                            focusColor: colorPrimaryText,
                            hoverColor: colorPrimaryText,
                          ),
                          Text(
                            'Male',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .apply(color: colorPrimaryText),
                          ),
                          Radio(
                            value: 1,
                            groupValue: _genderValue,
                            onChanged: _handleGenderChanged,
                            activeColor: colorPrimaryText,
                            focusColor: colorPrimaryText,
                            hoverColor: colorPrimaryText,
                          ),
                          Text(
                            'Female',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .apply(color: colorPrimaryText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  /*CustomTextField(
                    addressController,
                    _autoValidate,
                    TextInputType.text,
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_place_of_residence,
                    validator: (String text) {
                      */ /*if (text == '' && text.isEmpty) {
                        return ClubApp.por_empty_msg;
                      } else {
                        return null;
                      }*/ /*
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),*/
                  CustomTextField(
                    mobileController,
                    _autoValidate,
                    TextInputType.numberWithOptions(signed: true),
                    Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: colorPrimaryText),
                    ClubApp.hint_phone,
                    maxLength: 10,
                    validator: (String text) {
                      if (text == '' && text.isEmpty) {
                        return null;
                      } else if (text.trim().length != 10) {
                        return ClubApp.phone_valid_msg;
                      } else {
                        return null;
                      }
                      //return null;
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  RoundedButton(
                      buttonBackground,
                      12.0,
                      72.0,
                      ClubApp.label_sign_up,
                      Theme.of(context)
                          .textTheme
                          .subtitle1
                          .apply(color: Colors.white), onPressed: () async {
                    final FormState form = _formKey.currentState;
                    if (form.validate()) {
                      final bool isInternetAvailable =
                          await isNetworkAvailable();
                      if (isInternetAvailable) {
                        final String name = nameController.text.trim();
                        final String email = emailController.text.trim();
                        final String password = passwordController.text.trim();
                        final String confirmPassword =
                            confirmPasswordController.text.trim();
                        final String phone = mobileController.text.trim();
                        //final String address = addressController.text.trim();
                        String gender = '';
                        if (_genderValue != -1) {
                          if (_genderValue == 0) {
                            gender = 'Male';
                          } else {
                            gender = 'Female';
                          }
                        }
                        var registerUser = _signUpBloc.registerUser(name, email,
                            password, confirmPassword, phone, gender, context);
                      } else {
                        ackAlert(context, ClubApp.no_internet_message);
                      }
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  }),
                ],
              )),
          Container(
            margin: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                      ClubApp.already_have_account + ' ' + ClubApp.login,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .apply(color: colorPrimaryText)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: StreamBuilder<bool>(
            stream: _signUpBloc.loaderController.stream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              bool isLoading = false;
              if (snapshot.hasData) {
                isLoading = snapshot.data;
              }
              return ModalProgressHUD(
                inAsyncCall: isLoading,
                color: Colors.black,
                progressIndicator: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                dismissible: false,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: transparentBlack,
                    ),
                    Center(
                        child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: cardSignUp(),
                    )),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleGenderChanged(int value) {
    setState(() {
      _genderValue = value;
    });
  }
}
