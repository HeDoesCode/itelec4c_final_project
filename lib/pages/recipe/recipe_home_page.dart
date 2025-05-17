import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/auth_appbar.dart';
import 'package:itelec4c_final_project/components/recipe_list_item.dart';

class RecipeHomePage extends StatefulWidget {
  const RecipeHomePage({super.key});

  @override
  State<RecipeHomePage> createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(100, 255, 224, 178),
      appBar: AuthAppBar(),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(10),
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
                              return Center(child: CircularProgressIndicator());
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

                                return RecipeFeaturedItem(
                                  title: recipe['title'],
                                );
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
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(100, 201, 177, 145),
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
  final String title;

  const RecipeFeaturedItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Image(image: AssetImage('images/img_placeholder_rect.png')),
          Positioned(
            bottom: 0,
            left: 5,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
