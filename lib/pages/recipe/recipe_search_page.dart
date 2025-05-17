import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/recipe_list_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(100, 255, 224, 178),
      appBar: AppBar(
        title: Text("Dishly", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SearchBar(
                leading: Icon(Icons.search),
                hintText: "Seach recipes...",
                backgroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onSubmitted:
                    (value) => {
                      setState(() {
                        searchQuery = value.trim();
                      }),
                    },
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('tbl_recipes')
                          .where('title', isGreaterThanOrEqualTo: searchQuery)
                          .where('title', isLessThan: searchQuery + '\uf8ff')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (searchQuery.isNotEmpty && snapshot.data?.size == 0) {
                      return Center(
                        child: Text(
                          "No '$searchQuery' found",
                          style: TextStyle(fontSize: 24),
                        ),
                      );
                    }

                    var recipes = snapshot.data?.docs ?? [];

                    return ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        var recipe = recipes[index];

                        return RecipeListItem(
                          name: recipe['title'],
                          ingredients: "test",
                          category: recipe['category'],
                          time: recipe['cooking_time'].toString(),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
