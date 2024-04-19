import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

class CoachAthleteConnect extends StatefulWidget {
  const CoachAthleteConnect({super.key});

  @override
  State<CoachAthleteConnect> createState() => _CoachAthleteConnectState();
}

class _CoachAthleteConnectState extends State<CoachAthleteConnect> {
  late VideoPlayerController controller;
  late Future<void> _initializeVideoPlayerFuture;

  final supabase = Supabase.instance.client;
  dynamic athlete;
  dynamic videoUrl;
  dynamic athleteDetails;
  bool verified = false;
  bool isLoading = true;
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;
  dynamic accepted = false;

  final email = Supabase.instance.client.auth.currentUser!.email!;
  dynamic uId = Supabase.instance.client.auth.currentUser!.id;
  dynamic accountEmail;
  int followers = 0;
  int following = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  dynamic imageUrl;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      athlete = ModalRoute.of(context)?.settings.arguments as Map?;

      videoUrl = athlete['videoUrl'];
      controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      _initializeVideoPlayerFuture = controller.initialize();
      controller.pause();

      final followerResponse = await supabase
          .from('follow')
          .select('*')
          .eq('follower', athlete['uid']);
      followerCount = followerResponse.length;
      final followingResponse = await supabase
          .from('follow')
          .select('*')
          .eq('followed_by', athlete['uid']);
      followingCount = followingResponse.length;

      await getProfile();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future getProfile() async {
    athleteDetails = await supabase
        .from('profile')
        .select()
        .match({'user_id': athlete['uid']});
    verified = athleteDetails[0]['verified'];
    final id = athleteDetails[0]['id'];
    final supabase1 =
        SupabaseClient(dotenv.env['URL']!, dotenv.env['SECRET_KEY']!);

    final res =
        await supabase1.auth.admin.getUserById(athleteDetails[0]['user_id']);

    accountEmail = res.user!.email;
    if (athleteDetails[0]['image'] == true) {
      final String publicUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl('item_images/$id');

      setState(() {
        imageUrl = publicUrl;
      });
    }

    setState(() {
      accepted = athleteDetails[0]['accepted'];

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "Account Details",
            //       style: TextStyle(
            //           fontSize: 28,
            //           fontWeight: FontWeight.bold,
            //           fontFamily: 'Poppins'),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/picture_view',
                        arguments: {'imageUrl': imageUrl});
                  },
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        imageUrl != null ? NetworkImage(imageUrl) : null,
                    child: imageUrl == null
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '$followerCount',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoSlab'),
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          'followers',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoSlab'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          '$followingCount',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoSlab'),
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          'following',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoSlab'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            isLoading
                ? const Text("Loading...")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 60),
                      Text(
                        athleteDetails[0]['name'],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoSlab'),
                      ),
                      if (athleteDetails[0]['verified'])
                                                IconButton(
                                                  icon: Icon(Icons.verified),
                                                  color: Colors.blue,
                                                  onPressed: () {
                                                    // Handle onPressed action
                                                  },
                                                ),
                    ],
                  ),
            const SizedBox(height: 10),
            isLoading
                ? const Text("Loading...")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 60),
                      Text(
                        accountEmail,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoSlab'),
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, '/chat_page',
                        arguments: {'user_to': athleteDetails[0]['user_id']});
                  },
                  child: const Text(
                    'Message',
                    style: TextStyle(fontFamily: 'RobotoSlab'),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
  onPressed: verified ? null : () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Verify"),
          content: const Text("Are you sure you want to verify?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (!verified) {
                  verified = true;
                  await supabase
                      .from('profile')
                      .update({'verified': verified})
                      .match({'user_id': athleteDetails[0]['user_id']});
                }
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  },
  // Set the style of the button based on the value of 'verified'
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      verified ? Colors.grey : Colors.blue,
    ),
  ),
  // Set the text of the button based on the value of 'verified'
  child: Text(verified ? 'Verified' : 'Verify'),
)

              ],
            ),
            isLoading
                ? const Text("Loading...")
                : videoUrl == null
                    ? const Text('No Video Available')
                    : ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                        ),
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: Stack(
                                  children: [
                                    VideoPlayer(controller),
                                    Positioned(
                                      bottom: 20.0,
                                      right: 20.0,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          setState(() {
                                            if (controller.value.isPlaying) {
                                              controller.pause();
                                            } else {
                                              controller.play();
                                            }
                                          });
                                        },
                                        child: Icon(
                                          controller.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
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
                      ),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              accepted == true
                  ? const Text(
                      'Profile Accepted',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    )
                  : accepted == false && isLoading == false
                      ? const Text(
                          'Profile Rejected',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        )
                      : isLoading == false
                          ? Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm Accept"),
                                          content: const Text(
                                              "Are you sure you want to accept?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                await supabase
                                                    .from('profile')
                                                    .update({
                                                  'accepted': true
                                                }).eq(
                                                        'user_id',
                                                        athleteDetails[0]
                                                            ['user_id']);

                                                // ignore: use_build_context_synchronously
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Profile Accepted Successfully'),
                                                    duration:
                                                        Duration(seconds: 3),
                                                  ),
                                                );
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Yes"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("No"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  child: const Text('Accept'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm Reject"),
                                          content: const Text(
                                              "Are you sure you want to reject?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                await supabase
                                                    .from('profile')
                                                    .update({
                                                  'accepted': false
                                                }).eq(
                                                        'user_id',
                                                        athleteDetails[0]
                                                            ['user_id']);

                                                // ignore: use_build_context_synchronously
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Profile Rejected'),
                                                    duration:
                                                        Duration(seconds: 3),
                                                  ),
                                                );
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Yes"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("No"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: const Text('Reject'),
                                ),
                              ],
                            )
                          : const Text('')
              // : accepted == true
              //     ? const Text('Profile Accepted')
              //     : const Text('Profile Rejected'),
            ]
                // const SizedBox(width: 10),
                // ElevatedButton(
                //   onPressed: () {
                //     // ignore: use_build_context_synchronously
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AlertDialog(
                //           title: const Text("Confirm Reject"),
                //           content:
                //               const Text("Are you sure you want to reject?"),
                //           actions: [
                //             TextButton(
                //               onPressed: () async {
                //                 await supabase
                //                     .from('profile')
                //                     .update({'accepted': false}).eq('user_id',
                //                         athleteDetails[0]['user_id']);

                //                 // ignore: use_build_context_synchronously
                //                 ScaffoldMessenger.of(context).showSnackBar(
                //                   const SnackBar(
                //                     content:
                //                         Text('Profile Rejected'),
                //                     duration: Duration(seconds: 3),
                //                   ),
                //                 );
                //                 // ignore: use_build_context_synchronously
                //                 Navigator.of(context).pop();
                //               },
                //               child: const Text("Yes"),
                //             ),
                //             TextButton(
                //               onPressed: () async {
                //                 Navigator.of(context).pop();
                //               },
                //               child: const Text("No"),
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                //   child: const Text('Reject'),
                // ),
                //  :

                // children: [
                //   accepted == null
                //       ? ElevatedButton(
                //           onPressed: () async {
                //             // ignore: use_build_context_synchronously
                //             showDialog(
                //               context: context,
                //               builder: (BuildContext context) {
                //                 return AlertDialog(
                //                   title: const Text("Confirm Accept"),
                //                   content: const Text(
                //                       "Are you sure you want to accept?"),
                //                   actions: [
                //                     TextButton(
                //                       onPressed: () async {
                //                         await supabase
                //                             .from('profile')
                //                             .update({'accepted': true}).eq(
                //                                 'user_id',
                //                                 athleteDetails[0]['user_id']);

                //                         // ignore: use_build_context_synchronously
                //                         ScaffoldMessenger.of(context)
                //                             .showSnackBar(
                //                           const SnackBar(
                //                             content: Text(
                //                                 'Profile Accepted Successfully'),
                //                             duration: Duration(seconds: 3),
                //                           ),
                //                         );
                //                         // ignore: use_build_context_synchronously
                //                         Navigator.of(context).pop();
                //                       },
                //                       child: const Text("Yes"),
                //                     ),
                //                     TextButton(
                //                       onPressed: () async {
                //                         Navigator.of(context).pop();
                //                       },
                //                       child: const Text("No"),
                //                     ),
                //                   ],
                //                 );
                //               },
                //             );
                //           },
                //           style: ElevatedButton.styleFrom(
                //               backgroundColor: Colors.green),
                //           child: const Text('Accept'),
                //         )
                //       : const Text('Profile Accepted'),
                //   const SizedBox(width: 10),
                //   accepted == null
                //       ? ElevatedButton(
                //           onPressed: () {
                //             // ignore: use_build_context_synchronously
                //             showDialog(
                //               context: context,
                //               builder: (BuildContext context) {
                //                 return AlertDialog(
                //                   title: const Text("Confirm Reject"),
                //                   content: const Text(
                //                       "Are you sure you want to reject?"),
                //                   actions: [
                //                     TextButton(
                //                       onPressed: () async {
                //                         await supabase
                //                             .from('profile')
                //                             .update({'accepted': false}).eq(
                //                                 'user_id',
                //                                 athleteDetails[0]['user_id']);

                //                         // ignore: use_build_context_synchronously
                //                         ScaffoldMessenger.of(context)
                //                             .showSnackBar(
                //                           const SnackBar(
                //                             content: Text('Profile Rejected'),
                //                             duration: Duration(seconds: 3),
                //                           ),
                //                         );
                //                         // ignore: use_build_context_synchronously
                //                         Navigator.of(context).pop();
                //                       },
                //                       child: const Text("Yes"),
                //                     ),
                //                     TextButton(
                //                       onPressed: () async {
                //                         Navigator.of(context).pop();
                //                       },
                //                       child: const Text("No"),
                //                     ),
                //                   ],
                //                 );
                //               },
                //             );
                //           },
                //           style: ElevatedButton.styleFrom(
                //               backgroundColor: Colors.red),
                //           child: const Text('Reject'),
                //         )
                //       : const Text('Profile Rejected'),
                // ],
                )

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () async {
            //         // ignore: use_build_context_synchronously
            //         showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return AlertDialog(
            //               title: const Text("Confirm Accept"),
            //               content:
            //                   const Text("Are you sure you want to accept?"),
            //               actions: [
            //                 TextButton(
            //                   onPressed: () async {
            //                     await supabase
            //                         .from('profile')
            //                         .update({'accepted': true}).eq('user_id',
            //                             athleteDetails[0]['user_id']);

            //                     // ignore: use_build_context_synchronously
            //                     ScaffoldMessenger.of(context).showSnackBar(
            //                       const SnackBar(
            //                         content:
            //                             Text('Profile Accepted Successfully'),
            //                         duration: Duration(seconds: 3),
            //                       ),
            //                     );
            //                     // ignore: use_build_context_synchronously
            //                     Navigator.of(context).pop();
            //                   },
            //                   child: const Text("Yes"),
            //                 ),
            //                 TextButton(
            //                   onPressed: () async {
            //                     Navigator.of(context).pop();
            //                   },
            //                   child: const Text("No"),
            //                 ),
            //               ],
            //             );
            //           },
            //         );
            //       },
            //       style:
            //           ElevatedButton.styleFrom(backgroundColor: Colors.green),
            //       child: const Text('Accept'),
            //     ),
            //     const SizedBox(width: 10),
            //     ElevatedButton(
            //       onPressed: () {
            //         // ignore: use_build_context_synchronously
            //         showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return AlertDialog(
            //               title: const Text("Confirm Reject"),
            //               content:
            //                   const Text("Are you sure you want to reject?"),
            //               actions: [
            //                 TextButton(
            //                   onPressed: () async {
            //                     await supabase
            //                         .from('profile')
            //                         .update({'accepted': false}).eq('user_id',
            //                             athleteDetails[0]['user_id']);

            //                     // ignore: use_build_context_synchronously
            //                     ScaffoldMessenger.of(context).showSnackBar(
            //                       const SnackBar(
            //                         content:
            //                             Text('Profile Rejected'),
            //                         duration: Duration(seconds: 3),
            //                       ),
            //                     );
            //                     // ignore: use_build_context_synchronously
            //                     Navigator.of(context).pop();
            //                   },
            //                   child: const Text("Yes"),
            //                 ),
            //                 TextButton(
            //                   onPressed: () async {
            //                     Navigator.of(context).pop();
            //                   },
            //                   child: const Text("No"),
            //                 ),
            //               ],
            //             );
            //           },
            //         );
            //       },
            //       style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            //       child: const Text('Reject'),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
