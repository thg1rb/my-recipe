import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/providers/details_bar_provider.dart';

class Detail extends ConsumerWidget {
  const Detail({super.key, required this.recipe});
  final Map<String, dynamic> recipe;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int detailBarIdx = ref.watch(detailsBarProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(20),
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            if (detailBarIdx == 0)
              Text(recipe["description"])
            else if (detailBarIdx == 1)
              Text(recipe["ingredient"])
            else if (detailBarIdx == 2)
              Text(recipe["instruction"]),
          ],
        ),
      ),
    );
  }
}
