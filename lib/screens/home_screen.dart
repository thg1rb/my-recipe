import 'package:flutter/material.dart';
import 'package:my_recipe/widgets/home/home_category_list.dart';
import 'package:my_recipe/widgets/home/home_recipe_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          // TODO: Navigate to Create Recipe Screen
        },
        icon: Icon(Icons.add_rounded, size: 35),
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              HomeHeader(username: "kkerdsiri_", profileUrl: ""),
              HomeCategoryList(),
              HomeRecipeList(title: "แนะนำสำหรับคุณ"),
              HomeRecipeList(title: "Like มากที่สุด"),
              HomeRecipeList(title: "มีวิดีโอให้ดู"),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Header
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.username,
    required this.profileUrl,
  });

  final String username;
  final String profileUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Header Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "สวัสดี, $username",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "วันนี้คุณอยากทำเมนูอะไร?",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        // Header Profile Image
        // Image.network(profileUrl),
        ClipOval(
          // Circle profile image
          child: Image.asset(
            "assets/images/default-profile.jpg",
            width: 65,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
