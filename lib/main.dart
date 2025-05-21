import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/pages/account/account_login_page.dart';
import 'package:itelec4c_final_project/pages/account/account_signup_page.dart';
import 'package:itelec4c_final_project/pages/landing_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_home_page.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_search_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(Dishly());
}

class Dishly extends StatelessWidget {
  const Dishly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecipeHomePage(),
      routes: {
        '/login': (_) => LoginPage(),
        '/signup': (_) => SignUpPage(),
        '/reciple': (_) => RecipeHomePage(),
        '/recipe/search': (_) => SearchPage(),
      },
    );
  }
}
