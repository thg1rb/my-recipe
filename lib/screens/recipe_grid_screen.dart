import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe/services/recipe_service.dart';
import 'package:my_recipe/widgets/navigation_bar/top_navbar.dart';
import 'package:my_recipe/widgets/recipe_card.dart';

class RecipeGridScreen extends StatefulWidget {
  RecipeGridScreen({super.key, required String title}) : _title = title;

  final String _title;

  @override
  State<RecipeGridScreen> createState() => _RecipeGridScreenState();
}

class _RecipeGridScreenState extends State<RecipeGridScreen> {
  final RecipeService _recipeService = RecipeService();

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
                    search = value;
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
            StreamBuilder<QuerySnapshot>(
              stream: _recipeService.getRecipes(keyword: search),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No data'),
                  ); // TODO: Styling this message
                } else {
                  final recipeList =
                      snapshot.data!.docs
                          .map((recipe) => recipe.data())
                          .toList();
                  return Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 1, // Adjust this value as needed
                          ),
                      itemCount: recipeList.length,
                      itemBuilder:
                          (context, index) => RecipeCard(
                            recipe: recipeList[index] as Map<String, dynamic>,
                          ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
