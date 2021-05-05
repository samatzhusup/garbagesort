import 'package:flutter/material.dart';
import 'package:garbagesort/screens/auth/SignupPage.dart';
import 'screens/HomePage.dart';
import 'screens/auth/LoginPage.dart';
import 'splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => SignupPage(),

          //userRoutes
          '/userhome': (BuildContext context) => HomePage(),
        });
  }
}
