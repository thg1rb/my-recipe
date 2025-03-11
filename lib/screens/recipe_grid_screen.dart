import 'package:flutter/material.dart';
import 'package:my_recipe/widgets/navigation_bar/top_navbar.dart';
import 'package:my_recipe/widgets/recipe_card.dart';

class RecipeGridScreen extends StatelessWidget {
  const RecipeGridScreen({
    super.key,
    required List<Map<String, dynamic>>
    recipeList, // TODO: Delete this and use callback to get the data instead
    required String title,
  }) : _recipeList = recipeList,
       _title = title;

  final List<Map<String, dynamic>> _recipeList;
  final String _title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(title: _title, action: []),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            TextField(
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
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1, // Adjust this value as needed
                ),
                itemCount: _recipeList.length,
                itemBuilder:
                    (context, index) => RecipeCard(recipe: _recipeList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
