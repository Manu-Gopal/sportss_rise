// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({super.key});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();

//     controller = VideoPlayerController.networkUrl(
//       Uri.parse(
//         'https://wegdtcozojfvnnnlddbr.supabase.co/storage/v1/object/public/videos/cricket_videos/66c2db1c-19ef-409f-96da-a9f8a884184d20240314125115?t=2024-03-21T03%3A09%3A01.054Z',
//       ),
//     );

//     _initializeVideoPlayerFuture = controller.initialize();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Wrap the FutureBuilder with a Scaffold to add the FAB
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return AspectRatio(
//               aspectRatio: controller.value.aspectRatio,
//               child: Stack(
//                 children: [
//                   VideoPlayer(controller),
//                   // Position the FAB at the bottom right corner
//                   Positioned(
//                     bottom: 20.0,
//                     right: 20.0,
//                     child: FloatingActionButton(
//                       onPressed: () {
//                         // Add functionality for the FAB button here
//                         // For example, you could pause/play the video
                        
//                         setState(() {
//                           if (controller.value.isPlaying) {
//                           controller.pause();
//                         } else {
//                           controller.play();
//                         }
//                         });
//                       },
//                       child: Icon(
//                         controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// void main() => runApp(const VideoPlayerApp());

// class VideoPlayerApp extends StatelessWidget {
//   const VideoPlayerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Video Player Demo',
//       home: VideoPlayerScreen(),
//     );
//   }
// }

// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({super.key});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();

//     // Create and store the VideoPlayerController. The VideoPlayerController
//     // offers several different constructors to play videos from assets, files,
//     // or the internet.
//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse(
//         'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//       ),
//     );

//     // Initialize the controller and store the Future for later use.
//     _initializeVideoPlayerFuture = _controller.initialize();

//     // Use the controller to loop the video.
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     // Ensure disposing of the VideoPlayerController to free up resources.
//     _controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Butterfly Video'),
//       ),
//       // Use a FutureBuilder to display a loading spinner while waiting for the
//       // VideoPlayerController to finish initializing.
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the VideoPlayerController has finished initialization, use
//             // the data it provides to limit the aspect ratio of the video.
//             return AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               // Use the VideoPlayer widget to display the video.
//               child: VideoPlayer(_controller),
//             );
//           } else {
//             // If the VideoPlayerController is still initializing, show a
//             // loading spinner.
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Wrap the play or pause in a call to `setState`. This ensures the
//           // correct icon is shown.
//           setState(() {
//             // If the video is playing, pause it.
//             if (_controller.value.isPlaying) {
//               _controller.pause();
//             } else {
//               // If the video is paused, play it.
//               _controller.play();
//             }
//           });
//         },
//         // Display the correct icon depending on the state of the player.
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }
// }