import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/core/theme/custom_theme/color_scheme.dart';
import 'package:my_recipe/models/food_recipe.dart';

class RecipeScreen extends ConsumerWidget {
  const RecipeScreen({super.key, required this.recipe});

  final FoodRecipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(recipe.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 160),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    width: 350,
                    height: 142,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Text(
                            recipe.title,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '[06/02/2028 - 12:30:00]',
                            style: TextStyle(fontSize: 16),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'โดย: ',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: CustomColorScheme.blackColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'ไบรท์บวร',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: CustomColorScheme.yellowColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildIconText(icon: Icons.dining, text: recipe.difficulty),
                              _buildIconText(icon: Icons.remove_red_eye, text: '12345'),
                              _buildIconText(icon: Icons.favorite, text: recipe.likes.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildIconText({required IconData icon, required String text}) {
    Map<String, dynamic> difColors = {
      'ง่าย' : Colors.green,
      'ปานกลาง': Colors.orange,
      'ยาก': Colors.red,
    };

    final Color difTextColor;

    if (difColors.containsKey(text)) {
      difTextColor = difColors[text];
    } else {
      difTextColor = Colors.black;
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 16, color: difTextColor),
        ),
      ],
    );
  }
}
