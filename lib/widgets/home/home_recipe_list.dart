import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe/screens/recipe_grid_screen.dart';
import 'package:my_recipe/services/recipe_service.dart';
import 'package:my_recipe/widgets/recipe_card.dart';

class HomeRecipeList extends StatelessWidget {
  HomeRecipeList({super.key, required String title}) : _title = title;

  final String _title;
  final RecipeService _recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_title, style: Theme.of(context).textTheme.headlineMedium),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeGridScreen(title: _title),
                    ),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "เพิ่มเติม",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: StreamBuilder<QuerySnapshot>(
            stream: _recipeService.getRecipes(keyword: ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No data'));
              } else {
                final recipeList =
                    snapshot.data!.docs.map((recipe) => recipe.data()).toList();
                return ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: recipeList.length,
                  separatorBuilder: (context, index) => SizedBox(width: 6),
                  itemBuilder:
                      (context, index) => RecipeCard(
                        recipe: recipeList[index] as Map<String, dynamic>,
                      ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
