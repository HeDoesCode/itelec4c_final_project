import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/pages/profile/profile_details_page.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_details_page.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(
        username: "Julia",
        email: "maryjulia.malagayo.cics@ust.edu.ph",
      ),
    );
  }
}
