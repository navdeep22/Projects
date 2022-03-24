import 'package:club_app/ui/screens/landing.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:club_app/ui/screens/login.dart';
import 'package:club_app/ui/screens/splash.dart';
import 'package:club_app/constants/constants.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  //Workaround for the bug https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: primarySwatch,
          appBarTheme: const AppBarTheme(
            brightness: Brightness.dark,
            color: colorPrimary,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          textTheme: const TextTheme(
            // Text size 20
            headline6:
            TextStyle(fontWeight: FontWeight.w500, color: colorPrimaryDark),
            // Text size 14
            subtitle2: TextStyle(fontWeight: FontWeight.w500),
            // Text size 16
            subtitle1:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
            // Text size 14
            bodyText2:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
            // Text size 14
            bodyText1:
            TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            // Text size 12
            caption:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
            // Text size 10
            overline:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          )),
      home: LandingScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}
