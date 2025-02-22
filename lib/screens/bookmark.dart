import 'package:flutter/material.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "BOOKMARK",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
