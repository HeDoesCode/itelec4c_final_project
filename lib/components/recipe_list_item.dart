import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/transparent_btn.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_details_page.dart';
import 'package:itelec4c_final_project/services/favorite_recipe_service.dart';

class RecipeListItem extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> recipe;

  const RecipeListItem({super.key, required this.recipe});

  @override
  State<RecipeListItem> createState() => _RecipeListItemState();
}

class _RecipeListItemState extends State<RecipeListItem> {
  final FavoriteRecipeService _favoriteRecipeService = FavoriteRecipeService();
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    List userFavorites = await _favoriteRecipeService.getUserFavorites();

    setState(() {
      isFav = userFavorites.contains(widget.recipe.id);
    });
  }

  void handleFavoriteToggle() {
    isFav
        ? _favoriteRecipeService.removeFromFavorites(widget.recipe.id)
        : _favoriteRecipeService.addToFavorites(widget.recipe.id);

    setState(() {
      isFav = !isFav;
    });
  }

  String buildPreviewIngredients(List ingredients) {
    return ingredients.join(', ');
  }

  String buildImageFilename(String title) {
    String filename = "${title.replaceAll(" ", "-")}.jpg";
    return "images/recipes/$filename";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(recipe: widget.recipe),
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
                  image: AssetImage(buildImageFilename(widget.recipe['title'])),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recipe['title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        buildPreviewIngredients(widget.recipe['ingredients']),
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
                          widget.recipe['category'],
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            "${widget.recipe['cooking_time'].toString()} mins",
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
                iconLabel:
                    isFav
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                action: handleFavoriteToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
