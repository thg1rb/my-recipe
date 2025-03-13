import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe/widgets/navigation_bar/top_navbar.dart';
import 'package:my_recipe/widgets/recipe_card.dart';

class RecipeGridScreen extends StatefulWidget {
  const RecipeGridScreen({
    super.key,
    required String title,
    required Stream<QuerySnapshot> Function() queryBuilder,
  }) : _title = title,
       _queryBuilder = queryBuilder;

  final String _title;
  final Stream<QuerySnapshot> Function() _queryBuilder;

  @override
  State<RecipeGridScreen> createState() => _RecipeGridScreenState();
}

class _RecipeGridScreenState extends State<RecipeGridScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(title: widget._title, action: []),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            TextField(
              onChanged:
                  (value) => setState(() {
                    search =
                        value
                            .trim()
                            .toLowerCase(); // Make search case-insensitive
                  }),
              decoration: InputDecoration(
                labelText: 'ค้นหาสูตรอาหาร',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                prefixIcon: Icon(Icons.search_rounded),
                prefixIconColor: Theme.of(context).colorScheme.onSurface,
                filled: true,
                fillColor: Theme.of(context).colorScheme.onPrimary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10), // Add spacing between search and list
            Expanded(
              // Make sure the list/grid takes remaining space
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    widget
                        ._queryBuilder(), // No need to send search keyword here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'ไม่พบสูตรอาหาร',
                      ), // Thai message for "No recipes found"
                    );
                  } else {
                    // Map and filter recipes
                    final recipeList =
                        snapshot.data!.docs
                            .map(
                              (recipe) => recipe.data() as Map<String, dynamic>,
                            )
                            .where(
                              (recipe) =>
                                  recipe['name'] != null &&
                                  recipe['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains(search),
                            )
                            .toList();

                    if (recipeList.isEmpty) {
                      return Center(
                        child: Text(
                          'ไม่พบสูตรอาหารที่ตรงกับคำค้นหา',
                        ), // Thai message for "No matching recipes"
                      );
                    }

                    // Render Grid
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 1, // Adjust as needed
                          ),
                      itemCount: recipeList.length,
                      itemBuilder:
                          (context, index) =>
                              RecipeCard(recipe: recipeList[index]),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
