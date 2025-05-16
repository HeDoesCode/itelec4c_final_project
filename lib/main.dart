import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/pages/account/account_login_page.dart';
import 'package:itelec4c_final_project/pages/account/account_signup_page.dart';
import 'package:itelec4c_final_project/pages/landing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
      routes: {
        '/login': (_) => LoginPage(),
        '/signup': (_) => SignUpPage(),
        // '/recipes': (_) => RecipeListPage(),
      },
    );
  }
}
