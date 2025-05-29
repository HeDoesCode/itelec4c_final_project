import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/auth_appbar.dart';
import 'package:itelec4c_final_project/components/recipe_list_item.dart';

class RecipesFavoritePage extends StatefulWidget {
  const RecipesFavoritePage({super.key});

  @override
  State<RecipesFavoritePage> createState() => _RecipesFavoritePageState();
}

class _RecipesFavoritePageState extends State<RecipesFavoritePage> {
  List userFavorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    var userDetails =
        await FirebaseFirestore.instance
            .collection('tbl_users')
            .doc(currentUser!.uid)
            .get();

    setState(() {
      userFavorites = userDetails['favorites'] as List;
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 255, 224, 178),
      appBar: AuthAppBar(),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : userFavorites.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_remove_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No Favorite Recipes",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('tbl_recipes')
                        .where(FieldPath.documentId, whereIn: userFavorites)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var recipes = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      var recipe = recipes[index];

                      return RecipeListItem(recipe: recipe);
                    },
                  );
                },
              ),
    );
  }
}
