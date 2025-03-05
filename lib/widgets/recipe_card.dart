import 'package:flutter/material.dart';
import 'package:my_recipe/models/food_recipe.dart';
import 'package:my_recipe/screens/recipe_screen.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe
  }) ;

  final FoodRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder:(context) => RecipeScreen(recipe: recipe)));
        },
        child: SizedBox(
          width: 170,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    recipe.image,
                    width: double.infinity,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(recipe.title, style: Theme.of(context).textTheme.bodyMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.favorite_rounded, size: 15),
                          Text(
                            recipe.likes.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.local_dining_rounded, size: 15),
                          Text(
                            recipe.difficulty,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
