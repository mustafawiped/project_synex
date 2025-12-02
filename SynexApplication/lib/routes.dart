import 'package:flutter/material.dart';
import 'package:synex/pages/auth/loginpage/login_page.dart';
import 'package:synex/pages/auth/registerpage/register_page.dart';
import 'package:synex/pages/home/home_page.dart';
import 'package:synex/pages/splash/splash_page.dart';

class AppRoutes {
  static Map<String, StatefulWidget Function(dynamic)> routes(
      BuildContext context) {
    return {
      // splash page route
      SplashPage.routeName: (context) => SplashPage(),

      // home page route
      HomePage.routeName: (context) => HomePage(),

      // login page route
      LoginPage.routeName: (context) => LoginPage(),

      // register page route
      RegisterPage.routeName: (context) => RegisterPage(),
    };
  }
}
