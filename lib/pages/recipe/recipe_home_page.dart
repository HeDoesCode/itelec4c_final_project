import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/auth_appbar.dart';
import 'package:itelec4c_final_project/components/recipe_list_item.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_details_page.dart';
import 'package:itelec4c_final_project/components/bottom_appbar.dart'; // Import BottomNavBar
import 'package:itelec4c_final_project/pages/profile/profile_details_page.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_favorite_page.dart';

class RecipeHomePage extends StatefulWidget {
  const RecipeHomePage({super.key});

  @override
  State<RecipeHomePage> createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  int _selectedIndex = 0; // Set the initial page to Home

  // List of Pages to navigate to
  final List<Widget> _pages = [
    RecipeHomePage(), // Home Page
    FavoritesPage(), // Favorites Page
    ProfilePage(), // Profile Page
  ];

  // Handle navigation when tapping on a bottom navigation item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(100, 255, 224, 178),
      appBar: AuthAppBar(),
      body: SingleChildScrollView(
        // Wrap body in SingleChildScrollView
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(10),
            shrinkWrap:
                true, // Make sure it doesn’t take more space than necessary
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: "Featured Recipes"),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: StreamBuilder(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('tbl_recipes')
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              var recipes = snapshot.data?.docs ?? [];
                              var featuredRecipes = [];
                              final rand = Random();

                              for (int i = 0; i < 5; i++) {
                                featuredRecipes.add(recipes[rand.nextInt(70)]);
                              }
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: featuredRecipes.length,
                                itemBuilder: (context, index) {
                                  var recipe = featuredRecipes[index];
                                  return RecipeFeaturedItem(recipe: recipe);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: "All Recipes"),
                  StreamBuilder(
                    stream:
                        FirebaseFirestore.instance
                            .collection('tbl_recipes')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      var recipes = snapshot.data?.docs ?? [];

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          var recipe = recipes[index];
                          return RecipeListItem(recipe: recipe);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
    );
  }
}

class RecipeFeaturedItem extends StatelessWidget {
  final recipe;

  const RecipeFeaturedItem({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(recipe: recipe),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Image(image: AssetImage('images/img_placeholder_rect.png')),
            Positioned(
              bottom: 0,
              left: 5,
              child: Text(
                recipe['title'],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
