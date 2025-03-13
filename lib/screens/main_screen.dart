import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/providers/bottom_navbar_provider.dart';
import 'package:my_recipe/screens/bookmark_screen.dart';
import 'package:my_recipe/screens/home_screen.dart';
import 'package:my_recipe/screens/profile_screen.dart';
import 'package:my_recipe/widgets/navigation_bar/bottom_navbar.dart';

class MainScreen extends ConsumerWidget {
  MainScreen({super.key});

  final List<Widget> bottomNavbarScreens = <Widget>[
    HomeScreen(),
    BookmarkScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int bottomNavbarIndex = ref.watch(bottomNavbarIndexProvider);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: bottomNavbarScreens[bottomNavbarIndex],
      ),
      bottomNavigationBar: BottomNavbar(
        index: bottomNavbarIndex,
        onChangeIndex:
            (index) =>
                ref.read(bottomNavbarIndexProvider.notifier).state = index,
      ),
    );
  }
}
