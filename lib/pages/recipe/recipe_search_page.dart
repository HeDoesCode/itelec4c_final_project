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
  String selectedCategory = "All";
  final TextEditingController searchController = TextEditingController();

  // Budget filter values
  double _minBudget = 0;
  double _maxBudget = 1000; // Default max value - adjust as needed
  RangeValues _currentBudgetRange = RangeValues(0, 1000);
  bool _showBudgetFilter = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // List of categories - you can modify this based on your actual categories
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(100, 255, 224, 178),
      appBar: AppBar(
        title: Text("Dishly", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
        actions: [
          // Filter button to open the filters modal sheet
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
            // Search Bar
            SearchBar(
              controller: searchController,
              leading: Icon(Icons.search),
              hintText: "Search recipes...",
              backgroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onChanged: (value) {
                if (value.trim().isNotEmpty && selectedCategory != "All") {
                  setState(() {
                    selectedCategory = "All";
                  });
                }
              },
              onSubmitted: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),
            SizedBox(height: 15),

            // Active filters display
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

            // Results
            Expanded(
              child: StreamBuilder(
                stream: _getFilteredRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.data?.size == 0) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            _getNoResultsMessage(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  var recipes = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      var recipe = recipes[index];
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

  // Helper method to get active filters text
  String _getActiveFiltersText() {
    List<String> filters = [];

    if (selectedCategory != "All") {
      filters.add(selectedCategory);
    }

    if (_showBudgetFilter) {
      filters.add(
        "${_currentBudgetRange.start.round()}-${_currentBudgetRange.end.round()}",
      );
    }

    return filters.join(", ");
  }

  // Show the filters in a bottom sheet
  void _showFiltersBottomSheet(BuildContext context) {
    // Local variables to track changes without affecting the main state until applied
    String tempCategory = selectedCategory;
    bool tempShowBudgetFilter = _showBudgetFilter;
    RangeValues tempBudgetRange = _currentBudgetRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Filter Recipes",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempCategory = "All";
                                tempShowBudgetFilter = false;
                                tempBudgetRange = RangeValues(
                                  _minBudget,
                                  _maxBudget,
                                );
                              });
                            },
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category section
                            Text(
                              "Category",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  categories.map((category) {
                                    final isSelected = tempCategory == category;
                                    return FilterChip(
                                      label: Text(
                                        category,
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                        ),
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setModalState(() {
                                          tempCategory =
                                              selected
                                                  ? category
                                                  : tempCategory;
                                        });
                                      },
                                      selectedColor: Colors.orangeAccent,
                                      backgroundColor: Colors.grey.shade200,
                                      checkmarkColor: Colors.white,
                                    );
                                  }).toList(),
                            ),

                            SizedBox(height: 25),

                            // Budget filter section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Budget Filter",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Switch(
                                  value: tempShowBudgetFilter,
                                  activeColor: Colors.orangeAccent,
                                  onChanged: (value) {
                                    setModalState(() {
                                      tempShowBudgetFilter = value;
                                    });
                                  },
                                ),
                              ],
                            ),

                            if (tempShowBudgetFilter) ...[
                              SizedBox(height: 10),
                              Text(
                                "Set budget range: ${tempBudgetRange.start.round()} - ${tempBudgetRange.end.round()}",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              SizedBox(height: 5),
                              RangeSlider(
                                values: tempBudgetRange,
                                min: _minBudget,
                                max: _maxBudget,
                                divisions: 20,
                                activeColor: Colors.orangeAccent,
                                inactiveColor: Colors.grey.shade300,
                                labels: RangeLabels(
                                  "${tempBudgetRange.start.round()}",
                                  "${tempBudgetRange.end.round()}",
                                ),
                                onChanged: (RangeValues values) {
                                  setModalState(() {
                                    tempBudgetRange = values;
                                  });
                                },
                              ),
                              Text(
                                "Only show recipes within this budget range",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Apply button
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Apply the filters and close the sheet
                          setState(() {
                            selectedCategory = tempCategory;
                            _showBudgetFilter = tempShowBudgetFilter;
                            _currentBudgetRange = tempBudgetRange;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Apply Filters",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  // Helper method to generate appropriate no results message
  String _getNoResultsMessage() {
    List<String> filters = [];

    if (searchQuery.isNotEmpty) {
      filters.add("'$searchQuery'");
    }

    if (selectedCategory != "All") {
      filters.add("'$selectedCategory' category");
    }

    if (_showBudgetFilter) {
      filters.add(
        "budget \$${_currentBudgetRange.start.round()} - \$${_currentBudgetRange.end.round()}",
      );
    }

    if (filters.isEmpty) {
      return "No recipes found";
    } else if (filters.length == 1) {
      return "No recipes found for ${filters[0]}";
    } else {
      return "No recipes found matching ${filters.join(' and ')}";
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getFilteredRecipes() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(
      'tbl_recipes',
    );

    // Apply category filter if not "All"
    if (selectedCategory != "All") {
      query = query.where('category', isEqualTo: selectedCategory);
    }

    // Apply search filter if search query exists
    if (searchQuery.isNotEmpty) {
      // We need to create a case-insensitive search
      query = query
          .where('title', isGreaterThanOrEqualTo: searchQuery)
          .where('title', isLessThan: searchQuery + '\uf8ff');
    }

    // Get all recipes and filter client-side if budget filter is active
    if (_showBudgetFilter) {
      return query.snapshots().map((
        QuerySnapshot<Map<String, dynamic>> snapshot,
      ) {
        // Create a new snapshot from the results
        return FilteredQuerySnapshot(
          snapshot: snapshot,
          filterFn: (doc) {
            // Get the cost_estimate field from the document
            var budgetValue = doc.data()?['cost_estimate'];

            // Skip documents that don't have a budget value
            if (budgetValue == null) return false;

            // Convert to double if it's not already
            double budget =
                budgetValue is double
                    ? budgetValue
                    : double.tryParse(budgetValue.toString()) ?? 0;

            // Check if budget is within selected range
            return budget >= _currentBudgetRange.start &&
                budget <= _currentBudgetRange.end;
          },
        );
      });
    }

    // Return the original query if budget filter is not active
    return query.snapshots();
  }
}

// A more efficient way to handle filtered snapshots without implementing QuerySnapshot
class FilteredQuerySnapshot extends QuerySnapshot<Map<String, dynamic>> {
  final QuerySnapshot<Map<String, dynamic>> snapshot;
  final bool Function(QueryDocumentSnapshot<Map<String, dynamic>>) filterFn;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? _filteredDocs;

  FilteredQuerySnapshot({required this.snapshot, required this.filterFn});

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs {
    _filteredDocs ??= snapshot.docs.where(filterFn).toList();
    return _filteredDocs!;
  }

  @override
  List<DocumentChange<Map<String, dynamic>>> get docChanges => [];

  @override
  SnapshotMetadata get metadata => snapshot.metadata;

  @override
  int get size => docs.length;
}
