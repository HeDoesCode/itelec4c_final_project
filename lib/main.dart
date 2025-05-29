import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/pages/account/account_login_page.dart';
import 'package:itelec4c_final_project/pages/account/account_signup_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_home_page.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_search_page.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_favorite_page.dart';
import 'package:itelec4c_final_project/pages/profile/profile_details_page.dart';
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return LoginPage();
          }

          return MainPage();
        },
      ),
      routes: {
        '/login': (_) => LoginPage(),
        '/signup': (_) => SignUpPage(),
        '/recipe/search': (_) => SearchPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RecipeHomePage(), // Default page: Home
    RecipesFavoritePage(), // Favorites page
    ProfilePage(), // Profile page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: NavigationBar(
        backgroundColor: Color.fromARGB(255, 201, 177, 145),
        indicatorColor: Colors.orangeAccent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.bookmark), label: "Favorites"),
          NavigationDestination(
            icon: Icon(Icons.account_circle_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
