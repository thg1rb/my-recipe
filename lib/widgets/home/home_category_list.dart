import 'package:flutter/material.dart';

final List<Map<String, String>> categories = <Map<String, String>>[
  {"icon": "🍳", "type": "อาหารตามสั่ง"},
  {"icon": "🍜", "type": "ก๋วยเตี๋ยว"},
  {"icon": "🍔", "type": "ฟาสต์ฟู้ด"},
  {"icon": "🥗", "type": "สลัดและยำ"},
  {"icon": "🧋", "type": "เครื่องดื่ม"},
  {"icon": "🥨", "type": "ขนมทานเล่น"},
  {"icon": "🇯🇵", "type": "อาหารญี่ปุ่น"},
  {"icon": "🇰🇷", "type": "อาหารเกาหลี"},
  {"icon": "🇮🇳", "type": "อาหารอินเดีย"},
];

/// A widget that displays a list of recipe categories in a horizontal scrollable view.
class HomeCategoryList extends StatelessWidget {
  const HomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("หมวดหมู่", style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(
          height: 80,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => SizedBox(width: 6),
            itemBuilder:
                (context, index) => _CategoryCard(
                  categoryIcon: categories[index]["icon"] ?? '',
                  categoryTitle: categories[index]["type"] ?? '',
                ),
          ),
        ),
      ],
    );
  }
}

/// The `_CategoryCard` widget is used to display individual categories
/// within the home screen of the application.
///
/// Parameters:
/// - `_categoryName`: The name of the category to be displayed.
/// - `_icon`: The icon representing the category.
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required String categoryIcon,
    required String categoryTitle,
  }) : _categoryTitle = categoryTitle,
       _categoryIcon = categoryIcon;

  final String _categoryIcon;
  final String _categoryTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      clipBehavior:
          Clip.antiAliasWithSaveLayer, // Clip behavior to prevent overflow when hold InkWell
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          width: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Category Icon
              Text(
                _categoryIcon,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // Category Title
              Text(
                _categoryTitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
