import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/core/theme/custom_theme/color_scheme.dart';
import 'package:my_recipe/providers/details_bar_provider.dart';

class DetailsBar extends ConsumerWidget {
  DetailsBar({super.key});

  final List<String> detailList = ['รายละเอียด', 'วัตถุดิบ', 'ขั้นตอนวิธี'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int detailsBarSelectedIdx = ref.watch(detailsBarProvider);
    return Container(
      width: 333,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left:
                (detailsBarSelectedIdx * 111).toDouble(),
            child: Container(
              width: 111, height: 40, 
              decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < 3; i++)
                TextButton(
                  onPressed: () {
                    ref.read(detailsBarProvider.notifier).state = i;
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(110, 40),
                  ),
                  child: Text(
                    detailList[i],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          detailsBarSelectedIdx == i
                              ? CustomColorScheme.blackColor
                              : CustomColorScheme.yellowColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
