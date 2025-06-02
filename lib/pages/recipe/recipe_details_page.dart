import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/auth_appbar.dart';
import 'package:itelec4c_final_project/components/transparent_btn.dart';
import 'package:itelec4c_final_project/services/favorite_recipe_service.dart';

class RecipeDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

  String buildImageFilename(String title) {
    String filename = "${title.replaceAll(" ", "-")}.jpg";
    return "images/recipes/$filename";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 255, 224, 178),
      appBar: AuthAppBar(),
      body: Center(
        child: Column(
          children: [
            Header(recipe: recipe),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Image(image: AssetImage(buildImageFilename(recipe['title']))),
                  SizedBox(height: 20),
                  ListBuilder(
                    sectionTitle: "Ingredients",
                    list: recipe['ingredients'],
                  ),
                  SizedBox(height: 20),
                  ListBuilder(
                    sectionTitle: "Procedure",
                    list: recipe['instructions'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListBuilder extends StatelessWidget {
  final String sectionTitle;
  final List list;

  const ListBuilder({
    super.key,
    required this.sectionTitle,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.10),
            blurRadius: 3,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < list.length; i++)
                Text("${i + 1}. ${list[i]}"),
            ],
          ),
        ],
      ),
    );
  }
}

class Header extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> recipe;

  const Header({super.key, required this.recipe});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.recipe['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              overflow: TextOverflow.clip,
            ),
          ),
          TransparentButton(
            iconLabel: isFav ? Icons.bookmark : Icons.bookmark_border_rounded,
            action: handleFavoriteToggle,
          ),
        ],
      ),
    );
  }
}
