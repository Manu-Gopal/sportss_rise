import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://wegdtcozojfvnnnlddbr.supabase.co/storage/v1/object/public/videos/cricket_videos/66c2db1c-19ef-409f-96da-a9f8a884184d20240314125115?t=2024-03-21T03%3A09%3A01.054Z',
      ),
      // Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    );

    _initializeVideoPlayerFuture = controller.initialize();
    controller.pause();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      // Wrap the FutureBuilder with a Scaffold to add the FAB
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(controller),
                  // Position the FAB at the bottom right corner
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: FloatingActionButton(
                      onPressed: () {
                        // Add functionality for the FAB button here
                        // For example, you could pause/play the video
                        
                        setState(() {
                          if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                        });
                      },
                      child: Icon(
                        controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}