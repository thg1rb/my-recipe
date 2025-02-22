import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    super.key,
    required this.index,
    required this.onChangeIndex,
  });

  final int index;
  final Function(int) onChangeIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
      currentIndex: index,
      onTap: onChangeIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: (index == 0) ? Icon(Icons.home_rounded) : Icon(Icons.home_outlined),
          label: "หน้าหลัก",
        ),
        BottomNavigationBarItem(
          icon: (index == 1) ? Icon(Icons.bookmarks_rounded) : Icon(Icons.bookmarks_outlined),
          label: "บันทึกสูตร",
        ),
        BottomNavigationBarItem(
          icon: (index == 2) ? Icon(Icons.person_rounded) : Icon(Icons.person_outlined),
          label: "โปรไฟล์",
        ),
      ],
    );
  }
}
