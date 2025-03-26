import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/providers/bottom_navbar_provider.dart';
import 'package:my_recipe/screens/bookmark_screen.dart';
import 'package:my_recipe/screens/home_screen.dart';
import 'package:my_recipe/screens/profile_screen.dart';
import 'package:my_recipe/widgets/navigation_bar/bottom_navbar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final PageController _pageController = PageController();

  final List<Widget> bottomNavbarScreens = <Widget>[
    HomeScreen(),
    BookmarkScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int bottomNavbarIndex = ref.watch(bottomNavbarIndexProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            ref.read(bottomNavbarIndexProvider.notifier).state = index;
          },
          physics: const NeverScrollableScrollPhysics(),
          children: bottomNavbarScreens, // Disable manual swipe
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        index: bottomNavbarIndex,
        onChangeIndex: (index) {
          ref.read(bottomNavbarIndexProvider.notifier).state = index;
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
