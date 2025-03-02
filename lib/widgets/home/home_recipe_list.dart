import 'package:flutter/material.dart';
import 'package:my_recipe/core/theme/custom_theme/color_scheme.dart';
import 'package:my_recipe/models/food_recipe.dart';
import 'package:my_recipe/widgets/recipe_card.dart';

final List<Map<String, dynamic>> recipeList = <Map<String, dynamic>>[
  {
    "title": "กะเพราหมูเด้ง",
    "like": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
  },
  {
    "title": "กะเพราหมูเด้ง",
    "like": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
  },
  {
    "title": "กะเพราหมูเด้ง",
    "like": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
  },
  {
    "title": "กะเพราหมูเด้ง",
    "like": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
  },
  {
    "title": "กะเพราหมูเด้ง",
    "like": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
  },
];
final List<FoodRecipe> recipes = recipeList.map((map) => FoodRecipe.fromMap(map)).toList();

class HomeRecipeList extends StatelessWidget {
  const HomeRecipeList({super.key, required String title}) : _title = title;

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_title, style: Theme.of(context).textTheme.headlineMedium),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    "เพิ่มเติม",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CustomColorScheme.yellowColor,
                    ),
                  ),
                  Icon(Icons.navigate_next_rounded),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: recipeList.length,
            separatorBuilder: (context, index) => SizedBox(width: 6),
            itemBuilder:
                (context, index) => RecipeCard(recipe: recipes[index])
          ),
        ),
      ],
    );
  }
}
