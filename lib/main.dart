import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/pages/account/account_login_page.dart';
import 'package:itelec4c_final_project/pages/account/account_signup_page.dart';
import 'package:itelec4c_final_project/pages/auth_handler_page.dart';

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
      home: MainPage(), // AuthHandler should navigate to /main after login
      routes: {
        '/login': (_) => LoginPage(),
        '/signup': (_) => SignUpPage(),
        '/main': (_) => MainPage(), // Main page with bottom navigation
        '/reciple': (_) => RecipeHomePage(),
        '/recipe/search': (_) => SearchPage(),
        '/recipe/favorite': (_) => FavoritesPage(),
        '/profile': (_) => ProfilePage(),
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
    FavoritesPage(), // Favorites page
    ProfilePage(), // Profile page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(100, 201, 177, 145),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: const Color.fromARGB(100, 201, 177, 145),
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
