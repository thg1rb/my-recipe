import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_recipe/providers/details_bar_provider.dart';
import 'package:my_recipe/services/user_service.dart';
import 'video_player_widget.dart'; // Import the VideoPlayerWidget

class Detail extends ConsumerWidget {
  Detail({super.key, required this.recipe});

  final Map<String, dynamic> recipe;
  final User? user = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int detailBarIdx = ref.watch(detailsBarProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: StreamBuilder<bool?>(
          stream: _userService.isPremiumUser(user!.uid),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detailBarIdx == 2 &&
                    snapshot.data == true &&
                    recipe["videoUrl"] != "")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: VideoPlayerWidget(videoUrl: recipe["videoUrl"]),
                    ),
                  ),
                if (detailBarIdx == 0)
                  Text(
                    recipe["description"] ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                else if (detailBarIdx == 1)
                  Text(
                    recipe["ingredient"] ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                else if (detailBarIdx == 2)
                  Text(
                    recipe["instruction"] ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
