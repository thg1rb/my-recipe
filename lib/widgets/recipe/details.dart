import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_recipe/providers/details_bar_provider.dart';
import 'package:my_recipe/services/user_service.dart';
import 'video_player_widget.dart'; // Import the VideoPlayerWidget

class Detail extends ConsumerWidget {
  Detail({super.key, required this.recipe});

  final Map<String, dynamic> recipe;
  final User? _user = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int detailBarIdx = ref.watch(detailsBarProvider);

    final MarkdownStyleSheet markdownStyleSheet = MarkdownStyleSheet(
      h1: Theme.of(context).textTheme.headlineLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      h2: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      h3: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: 22,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      h4: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      h5: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 18,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      p: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 2,
        shadowColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 400,
          color: Theme.of(context).colorScheme.onPrimary,
          child: StreamBuilder<bool?>(
            stream: _userService.isPremiumUser(_user!.uid),
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((detailBarIdx == 2 &&
                          snapshot.data == true &&
                          recipe["videoUrl"] != "") ||
                      (detailBarIdx == 2 &&
                          _user.uid == recipe["userId"] &&
                          recipe["videoUrl"] != ""))
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
                    MarkdownBody(
                      data: recipe["description"] ?? "",
                      styleSheet: markdownStyleSheet,
                    )
                  else if (detailBarIdx == 1)
                    MarkdownBody(
                      data: recipe["ingredient"] ?? "",
                      styleSheet: markdownStyleSheet,
                    )
                  else if (detailBarIdx == 2)
                    MarkdownBody(
                      data: recipe["instruction"] ?? "",
                      styleSheet: markdownStyleSheet,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
