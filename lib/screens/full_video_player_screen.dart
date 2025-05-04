import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            /// Video player
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),

            /// Video progress bar
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(playedColor: Colors.red),
              ),
            ),

            /// Control buttons (bottom center)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Backward 10 sec
                  IconButton(
                    icon: const Icon(
                      Icons.replay_10,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: () async {
                      final currentPosition = await controller.position;
                      if (currentPosition != null) {
                        final newPosition =
                            currentPosition - const Duration(seconds: 10);
                        controller.seekTo(
                          newPosition > Duration.zero
                              ? newPosition
                              : Duration.zero,
                        );
                      }
                    },
                  ),

                  const SizedBox(width: 16),

                  /// Play/Pause
                  IconButton(
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      setState(() {
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      });
                    },
                  ),

                  const SizedBox(width: 16),

                  /// Forward 10 sec
                  IconButton(
                    icon: const Icon(
                      Icons.forward_10,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: () async {
                      final currentPosition = await controller.position;
                      final maxDuration = controller.value.duration;
                      if (currentPosition != null) {
                        final newPosition =
                            currentPosition + const Duration(seconds: 10);
                        controller.seekTo(
                          newPosition < maxDuration ? newPosition : maxDuration,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            /// Exit fullscreen (top-left)
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 36),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
