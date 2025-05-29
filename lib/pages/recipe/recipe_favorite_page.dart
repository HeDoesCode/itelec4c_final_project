import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // to get current user
import 'package:itelec4c_final_project/components/recipe_list_item.dart';
//import 'package:itelec4c_final_project/components/bottom_appbar.dart'; // Import your BottomNavBar component
import 'package:itelec4c_final_project/pages/recipe/recipe_home_page.dart';
import 'package:itelec4c_final_project/pages/profile/profile_details_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String selectedCategory = "All";

  // Budget filter values
  double _minBudget = 0;
  double _maxBudget = 1000;
  RangeValues _currentBudgetRange = RangeValues(0, 1000);
  bool _showBudgetFilter = false;

  final List<String> categories = [
    "All",
    "Breakfast",
    "Lunch",
    "Dinner",
    "Snacks",
    "Dessert",
    "Vegetarian",
    "Non-Vegetarian",
    "Vegan",
    "Drinks",
    "Soups & Stews",
  ];

  User? currentUser = FirebaseAuth.instance.currentUser;

  int _selectedIndex = 1; // Set the initial page to Favorites

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
    if (currentUser == null) {
      return Center(child: Text("Please login to see favorites"));
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(100, 255, 224, 178),
      appBar: AppBar(
        title: Text("Favorites", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () => _showFiltersBottomSheet(context),
              ),
              if (_showBudgetFilter || selectedCategory != "All")
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            if (_showBudgetFilter || selectedCategory != "All") ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      size: 16,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Filters: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _getActiveFiltersText(),
                        style: TextStyle(color: Colors.grey.shade800),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = "All";
                          _showBudgetFilter = false;
                        });
                      },
                      child: Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
            ],
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: _getFavoriteRecipesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  var recipes = snapshot.data ?? [];

                  if (recipes.isEmpty) {
                    return Center(child: Text("No favorite recipes found."));
                  }

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      // Cast to the correct type
                      var recipe =
                          recipes[index]
                              as QueryDocumentSnapshot<Map<String, dynamic>>;
                      return RecipeListItem(recipe: recipe);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getActiveFiltersText() {
    List<String> filters = [];
    if (selectedCategory != "All") filters.add(selectedCategory);
    if (_showBudgetFilter) {
      filters.add(
        "${_currentBudgetRange.start.round()}-${_currentBudgetRange.end.round()}",
      );
    }
    return filters.join(", ");
  }

  void _showFiltersBottomSheet(BuildContext context) {
    // Reuse the filter bottom sheet from SearchPage here.
    // Make sure you have the same logic for updating selectedCategory, _showBudgetFilter, and _currentBudgetRange.
  }

  Stream<List<DocumentSnapshot>> _getFavoriteRecipesStream() async* {
    // Get user's favorite recipe IDs
    final favCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('favorites');

    // Listen to favorite recipe IDs changes
    final favSnapshot = await favCollection.get();

    List<String> favoriteIds = favSnapshot.docs.map((doc) => doc.id).toList();

    if (favoriteIds.isEmpty) {
      yield [];
      return;
    }

    // Query recipes where document ID is in favoriteIds
    Query<Map<String, dynamic>> baseQuery = FirebaseFirestore.instance
        .collection('tbl_recipes');

    if (selectedCategory != "All") {
      baseQuery = baseQuery.where('category', isEqualTo: selectedCategory);
    }

    // Firestore has a limitation of 10 elements in "whereIn"
    // So chunk favoriteIds if necessary
    List<List<String>> chunks = [];
    for (var i = 0; i < favoriteIds.length; i += 10) {
      chunks.add(
        favoriteIds.sublist(
          i,
          i + 10 > favoriteIds.length ? favoriteIds.length : i + 10,
        ),
      );
    }

    // For each chunk query snapshots and combine them client side
    List<DocumentSnapshot> combinedResults = [];

    for (var chunk in chunks) {
      final querySnapshot =
          await baseQuery.where(FieldPath.documentId, whereIn: chunk).get();
      combinedResults.addAll(querySnapshot.docs);
    }

    // Apply budget filtering client-side
    if (_showBudgetFilter) {
      combinedResults =
          combinedResults.where((doc) {
            final data = doc.data() as Map<String, dynamic>?;

            if (data == null) return false;

            var budgetValue = data['cost_estimate'];
            if (budgetValue == null) return false;

            double budget =
                budgetValue is double
                    ? budgetValue
                    : double.tryParse(budgetValue.toString()) ?? 0;
            return budget >= _currentBudgetRange.start &&
                budget <= _currentBudgetRange.end;
          }).toList();
    }

    yield combinedResults;
  }
}
