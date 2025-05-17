import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/transparent_btn.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_details_page.dart';

class RecipeListItem extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> recipe;

  const RecipeListItem({super.key, required this.recipe});

  String buildIngredientString(List ingredients) {
    return ingredients.join(', ');
  }

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Stack(
          children: [
            Row(
              children: [
                Image(
                  width: 125,
                  image: AssetImage('images/img_placeholder_square.png'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe['title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        recipe.data().containsKey('ingredients')
                            ? buildIngredientString(recipe['ingredients'])
                            : "No ingredients listed",
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.orangeAccent,
                        ),
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Text(
                          recipe['category'],
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            "${recipe['cooking_time'].toString()} mins",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 5,
              child: TransparentButton(
                iconLabel: Icons.bookmark_border_rounded,
                action: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
