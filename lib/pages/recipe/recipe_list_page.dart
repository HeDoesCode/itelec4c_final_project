import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/auth_appbar.dart';
import 'package:itelec4c_final_project/components/recipe_featured_item.dart';
import 'package:itelec4c_final_project/components/recipe_list_item.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(100, 255, 224, 178),
      appBar: AuthAppBar(),
      body: Center(
        child: ListView(
          children: [
            RecipeFeaturedItem(),
            RecipeListItem(
              name: 'Lorem Ipsum',
              ingredients: 'ingredient 1, ingredient 2, 3+',
              category: 'food',
              time: 23,
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
