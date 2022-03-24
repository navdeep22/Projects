import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterbuyandsell/ui/vender_screens/my_listing.dart';
import 'package:flutterbuyandsell/ui/vender_screens/packages.dart';
import 'package:flutterbuyandsell/ui/vender_screens/purchase_history.dart';
import 'package:flutterbuyandsell/ui/vender_screens/add_listing.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VenderDashboard extends StatefulWidget {
  const VenderDashboard({Key key}) : super(key: key);

  @override
  _VenderDashboardState createState() => _VenderDashboardState();
}

class _VenderDashboardState extends State<VenderDashboard> {
  int _selectedIndex = 0;
  Color primaryColor = PsColors.mainColor;
  String venderName = '';
  String venderEmail;
  String venderPhone;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _venderName = await prefs.getString('vender_user_name');
    var _venderEmail = await prefs.getString('vender_user_email');
    var _venderPhone = await prefs.getString('vender_user_phone');
    setState(() {
      venderName = _venderName;
      venderPhone = _venderPhone;
      venderEmail = _venderEmail;
    });
  }

  Widget buildTitle() {
    if (_selectedIndex == 0) {
      return Text('My Listing');
    } else if (_selectedIndex == 1) {
      return Text('Add Listing');
    } else if (_selectedIndex == 2) {
      return Text('Packages');
    } else if (_selectedIndex == 3) {
      return Text('Purchase History');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: buildTitle(), actions: <Widget>[
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('loginAsVender', false);
                await prefs.setString('vender_user_id', '');
                await prefs.setString('vender_user_name', '');
                await prefs.setString('vender_user_email', '');

                await prefs.setString('vender_user_phone', '');
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: Icon(Icons.logout_rounded))
        ]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          showUnselectedLabels: true,
          backgroundColor: PsColors.backgroundColor,
          selectedItemColor: PsColors.mainColor,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list_rounded,
                size: 20,
              ),
              label: 'My Listing',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_rounded,
                size: 20,
              ),
              label: 'Add Listing',
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.playlist_add_check,
                size: 20,
              ),
              label: 'Package',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.history_rounded,
                  size: 20,
                ),
                label: 'History'),
          ],
        ),
        drawer: Drawer(
          child: Builder(builder: (BuildContext context) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerHeaderWidget(),
                ListTile(
                  title: Text('Vender Dashboard'),
                ),
                _DrawerMenuWidget(
                    icon: Icons.list_rounded,
                    title: 'My Listing',
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      setState(() {
                        _selectedIndex = 0;
                      });
                    }),
                _DrawerMenuWidget(
                    icon: Icons.add_rounded,
                    title: 'Add Listing',
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      setState(() {
                        _selectedIndex = 1;
                      });
                    }),
                _DrawerMenuWidget(
                    icon: Icons.playlist_add_check,
                    title: "Packages",
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      setState(() {
                        _selectedIndex = 2;
                      });
                    }),
                _DrawerMenuWidget(
                    icon: Icons.history_rounded,
                    title: 'Package History',
                    onTap: (String title, int index) {
                      Navigator.pop(context);
                      setState(() {
                        _selectedIndex = 3;
                      });
                    }),
              ],
            );
          }),
        ),
        body: Builder(builder: (BuildContext context) {
          if (_selectedIndex == 0) {
            return const MyListing();
          } else if (_selectedIndex == 1) {
            return const AddListing();
          } else if (_selectedIndex == 2) {
            return const Packages();
          } else {
            return const PurchaseHistory();
          }
        }),
      ),
    );
  }

  Widget _DrawerHeaderWidget() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/user_default_photo.png',
            width: PsDimens.space100,
            height: PsDimens.space72,
          ),
          const SizedBox(
            height: PsDimens.space8,
          ),
          Text(
            // Utils.getString(context, 'app_name'),
            venderName,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: PsColors.white, fontSize: 20),
          ),
          Text(
            // Utils.getString(context, 'app_name'),
            venderEmail,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: PsColors.white),
          ),
          // Text(
          //   // Utils.getString(context, 'app_name'),
          //   venderPhone,
          //   style: Theme.of(context)
          //       .textTheme
          //       .subtitle1
          //       .copyWith(color: PsColors.white),
          // ),
        ],
      ),
      decoration: BoxDecoration(color: PsColors.mainColor),
    );
  }
}

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: PsColors.mainColorWithWhite),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}
