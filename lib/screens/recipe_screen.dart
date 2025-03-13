import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/widgets/navigation_bar/top_navbar.dart';
import 'package:my_recipe/widgets/recipe/details.dart';
import 'package:my_recipe/widgets/recipe/details_bar.dart';

class RecipeScreen extends ConsumerWidget {
  RecipeScreen({super.key, required this.recipe});

  final Map<String, dynamic> recipe;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: TopNavBar(
        title: "",
        action: [
          if (user?.uid == recipe["userId"])
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/post', arguments: recipe);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                recipe["imageUrl"].toString().isEmpty
                    ? Container(
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 230,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "ไม่พบรูปภาพ",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    )
                    : Container(
                      height: 230,
                      width: double.infinity,
                      child: Image.network(
                        recipe["imageUrl"],
                        fit: BoxFit.cover,
                      ),
                    ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 160,
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1,
                    bottom: 12,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        width: 350,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: [
                              Text(
                                recipe["name"],
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "[${DateTime.fromMillisecondsSinceEpoch(recipe["createdAt"].millisecondsSinceEpoch).toLocal().toString().split('.')[0]}]",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildIconText(
                                    context,
                                    icon: Icons.dining,
                                    text: recipe["difficulty"],
                                  ),
                                  _buildIconText(
                                    context,
                                    icon: Icons.remove_red_eye,
                                    text: recipe["views"].toString(),
                                  ),
                                  _buildIconText(
                                    context,
                                    icon: Icons.favorite,
                                    text: recipe["likes"].toString(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            DetailsBar(),
            SizedBox(height: 10),
            Detail(recipe: recipe),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    Map<String, dynamic> difColors = {
      'ง่าย': Colors.green,
      'ปานกลาง': Colors.orange,
      'ยาก': Colors.red,
    };

    final Color difTextColor;

    if (difColors.containsKey(text)) {
      difTextColor = difColors[text];
    } else {
      difTextColor = Theme.of(context).colorScheme.onSurface;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16, color: difTextColor)),
      ],
    );
  }
}
