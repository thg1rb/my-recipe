import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/core/theme/theme.dart';
import 'package:my_recipe/providers/bottom_navbar_provider.dart';
import 'package:my_recipe/screens/bookmark.dart';
import 'package:my_recipe/screens/home.dart';
import 'package:my_recipe/screens/profile.dart';
import 'package:my_recipe/widgets/bottom_navbar.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final List<Widget> bottomNavbarScreens = <Widget>[
    HomeScreen(),
    BookmarkScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int bottomNavbarIndex = ref.watch(bottomNavbarIndexProvider);
    return MaterialApp(
      title: 'MyRecipe!',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      home: Scaffold(
        body: bottomNavbarScreens[bottomNavbarIndex],
        bottomNavigationBar: BottomNavbar(
          index: bottomNavbarIndex,
          onChangeIndex:
              (index) => ref.read(bottomNavbarIndexProvider.notifier).state = index,
        ),
      ),
    );
  }
}
