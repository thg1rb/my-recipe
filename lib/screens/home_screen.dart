import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe/screens/post_screen.dart';
import 'package:my_recipe/services/recipe_service.dart';
import 'package:my_recipe/services/user_service.dart';
import 'package:my_recipe/widgets/home/carousel_ads.dart';
import 'package:my_recipe/widgets/home/home_category_list.dart';
import 'package:my_recipe/widgets/home/home_recipe_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final RecipeService _recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).push(createRoute());
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
              _HomeHeader(),
              CarouselAds(),
              HomeCategoryList(),
              HomeRecipeList(
                title: "แนะนำสำหรับคุณ",
                queryBuilder: _recipeService.getRecipes,
              ),
              HomeRecipeList(
                title: "Like มากที่สุด",
                queryBuilder: _recipeService.getMostLikedRecipes,
              ),
              HomeRecipeList(
                title: "มีวิดีโอให้ดู",
                queryBuilder: _recipeService.getRecipesWithVideo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Header
class _HomeHeader extends StatelessWidget {
  _HomeHeader();

  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";

    // Check if the user is signed out (userId is empty)
    if (userId.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Header Text for signed-out users
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "สวัสดี, ผู้ใช้",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "วันนี้คุณอยากทำเมนูอะไร?",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          // Header Profile Image for signed-out users
          ClipOval(
            child: Image.asset(
              "assets/images/default-profile.jpg",
              width: 65,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }

    return StreamBuilder<DocumentSnapshot?>(
      stream: _userService.getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('User not found');
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String username = userData['username'] ?? 'No Username';
          final String profileUrl = userData['profileUrl'] ?? '';

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
              ClipOval(
                // Circle profile image
                child:
                    profileUrl.isNotEmpty
                        ? Image.network(
                          profileUrl,
                          width: 65,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(
                          "assets/images/default-profile.jpg",
                          width: 65,
                          fit: BoxFit.cover,
                        ),
              ),
            ],
          );
        }
      },
    );
  }
}


