import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/constants/validator.dart';
import 'package:club_app/logic/bloc/guest_list_bloc.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/custom_text_field.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class GuestList extends StatefulWidget {
  @override
  _GuestListState createState() => _GuestListState();
}

class _GuestListState extends State<GuestList> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController menCountController = new TextEditingController();
  TextEditingController womenCountController = new TextEditingController();
  TextEditingController referenceController = new TextEditingController();
  bool _autoValidate = false;
  final GlobalKey _formKey = GlobalKey<FormState>();
  GuestListBloc guestListBloc;
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode menCountFocusNode = FocusNode();
  FocusNode womenCountFocusNode = FocusNode();
  FocusNode referenceNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    guestListBloc = GuestListBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(ClubApp.guest_list),
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
        child: StreamBuilder<bool>(
          stream: guestListBloc.loaderController.stream,
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
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: guestRegister(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    //margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                    color: detailsDividerColor,
                  ),
                  requestButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget guestRegister() {
    return ListView(shrinkWrap: true, children: <Widget>[
      Text(ClubApp.guest_list_info,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey)),
      seperater(16.0),
      nameWidget(),
      seperater(10.0),
      emailWidget(),
      seperater(10.0),
      phoneWidget(),
      seperater(10.0),
      menCountWidget(),
      seperater(10.0),
      womenCountWidget(),
      seperater(10.0),
      referenceNameWidget(),
      seperater(16.0),
    ]);
  }

  Widget nameWidget() {
    return CustomTextField(
      nameController,
      _autoValidate,
      TextInputType.text,
      Theme.of(context).textTheme.bodyText2.apply(color: colorPrimaryText),
      ClubApp.hint_name,
      validator: (String text) {
        if (text == '' && text.isEmpty) {
          return ClubApp.name_empty_msg;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onFieldSubmitted: (text) {
        FocusScope.of(context).requestFocus(emailFocusNode);
      },
    );
  }

  Widget emailWidget() {
    return CustomTextField(
      emailController,
      _autoValidate,
      TextInputType.emailAddress,
      Theme.of(context).textTheme.bodyText2.apply(color: colorPrimaryText),
      ClubApp.hint_email,
      validator: (String text) {
        return Validator.validateEmail(text);
      },
      inputAction: TextInputAction.next,
      focusNode: emailFocusNode,
      onFieldSubmitted: (text) {
        FocusScope.of(context).requestFocus(phoneFocusNode);
      },
    );
  }

  Widget phoneWidget() {
    return CustomTextField(
      phoneNumberController,
      _autoValidate,
      TextInputType.number,
      Theme.of(context).textTheme.bodyText2.apply(color: colorPrimaryText),
      ClubApp.hint_phone,
      validator: (String text) {
        return Validator.validateMobile(text);
      },
      inputAction: TextInputAction.next,
      focusNode: phoneFocusNode,
      onFieldSubmitted: (text) {
        FocusScope.of(context).requestFocus(menCountFocusNode);
      },
    );
  }

  Widget menCountWidget() {
    return CustomTextField(
      menCountController,
      _autoValidate,
      TextInputType.number,
      Theme.of(context).textTheme.bodyText2.apply(color: colorPrimaryText),
      ClubApp.men_count,
      validator: (String text) {
        return Validator.validateCount(text);
      },
      inputAction: TextInputAction.next,
      focusNode: menCountFocusNode,
      onFieldSubmitted: (text) {
        FocusScope.of(context).requestFocus(womenCountFocusNode);
      },
    );
  }

  Widget womenCountWidget() {
    return CustomTextField(
      womenCountController,
      _autoValidate,
      TextInputType.number,
      Theme.of(context).textTheme.bodyText2.apply(color: colorPrimaryText),
      ClubApp.women_count,
      validator: (String text) {
        return Validator.validateCount(text);
      },
      inputAction: TextInputAction.next,
      focusNode: womenCountFocusNode,
      onFieldSubmitted: (text) {
        FocusScope.of(context).requestFocus(referenceNameFocusNode);
      },
    );
  }

  Widget referenceNameWidget() {
    return CustomTextField(
      referenceController,
      _autoValidate,
      TextInputType.text,
      Theme.of(context).textTheme.bodyText2.apply(color: colorPrimaryText),
      ClubApp.reference_name,
      validator: (String text) {
        if (text == '' && text.isEmpty) {
          return ClubApp.reference_empty_msg;
        } else {
          return null;
        }
      },
      focusNode: referenceNameFocusNode,
    );
  }


  Widget requestButton() {
    return Container(
        color: cardBackgroundColor,
//      color: Colors.grey.withAlpha(75),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        alignment: Alignment.center,
        child: OutlineBorderButton(
            buttonBackground,
            8.0,
            32.0,
            ClubApp.request,
            Theme.of(context)
                .textTheme
                .subtitle1
                .apply(color: Colors.white),
            onPressed: () async {
              final FormState form = _formKey.currentState;
              if (form.validate()) {
                final bool isInternetAvailable = await isNetworkAvailable();
                if (isInternetAvailable) {
                  final String name = nameController.text.trim();
                  final String email = emailController.text.trim();
                  final String phoneNumber = phoneNumberController.text.trim();
                  final String referenceName = referenceController.text.trim();
                  final int womenCount = int.parse(womenCountController.text.trim());
                  final int menCount = int.parse(menCountController.text.trim());
                  guestListBloc.guestListAdd(name, email, phoneNumber, menCount, womenCount, referenceName, context);
                } else {
                  ackAlert(context, ClubApp.no_internet_message);
                }
              } else {
                setState(() {
                  _autoValidate = true;
                });
              }
            }),
        //child:
    );
    /*return  OutlineButton(
      onPressed: () async {
        final FormState form = _formKey.currentState;
        if (form.validate()) {
          final bool isInternetAvailable = await isNetworkAvailable();
          if (isInternetAvailable) {
            final String name = nameController.text.trim();
            final String email = emailController.text.trim();
            final int phoneNumber = int.parse(phoneNumberController.text.trim());
            final String referenceName = referenceController.text.trim();
            final int womenCount = int.parse(womenCountController.text.trim());
            final int menCount = int.parse(menCountController.text.trim());
            guestListBloc.guestListAdd(name, email, phoneNumber, menCount, womenCount, referenceName, context);
          } else {
            ackAlert(context, ClubApp.no_internet_message);
          }
        } else {
          setState(() {
            _autoValidate = true;
          });
        }
      },
      borderSide: BorderSide(color: borderColor),
      child: Text(
          ClubApp.request,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .apply(color: Colors.white),
      ),
    );*/
  }

  Widget seperater(double size) {
    return SizedBox(
      height: size,
    );
  }

  @override
  void dispose() {
    guestListBloc.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    menCountController.dispose();
    womenCountController.dispose();
    referenceController.dispose();
    super.dispose();
  }
}
