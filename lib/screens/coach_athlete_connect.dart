import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'video_player_screen.dart';

class CoachAthleteConnect extends StatefulWidget {
  const CoachAthleteConnect({super.key});

  @override
  State<CoachAthleteConnect> createState() => _CoachAthleteConnectState();
}

class _CoachAthleteConnectState extends State<CoachAthleteConnect> {
  final supabase = Supabase.instance.client;
  dynamic athlete;
  dynamic athleteDetails;
  bool isLoading = true;
  bool isFollowing = false;

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
      await getProfile();
    });
  }

  Future getProfile() async {
    athleteDetails = await supabase
        .from('profile')
        .select()
        .match({'user_id': athlete['uid']});
    final id = athleteDetails[0]['id'];
    followers = athleteDetails[0]['followers'] as int;
    following = athleteDetails[0]['following'] as int;
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
      isLoading = false;
    });
  }

  // Future updateFollowStatus() async {
  //   final updateResponse1 = await supabase.from('profile').update({
  //     'followers': isFollowing ? followers + 1 : followers - 1,
  //   }).match({'user_id': athlete['uid']});

  //   final updateResponse2 = await supabase.from('profile').update({
  //     'following': isFollowing ? following + 1 : following - 1,
  //   }).match({'user_id': uId});

  //   if (updateResponse1.error != null || updateResponse2.error != null) {
  //     // Handle errors (optional)
  //     // print('Error updating follower counts: ${updateResponse1.error}');
  //     // print('Error updating following: ${updateResponse2.error}');
  //   } else {
  //     setState(() {
  //       followers = isFollowing ? followers + 1 : followers - 1;
  //       following = isFollowing ? following + 1 : following - 1;
  //       isFollowing = !isFollowing;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            // const SizedBox(height: 80),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Account Details",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 40),
                Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: imageUrl != null
                        ? CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(imageUrl),
                          )
                        : const CircleAvatar(
                            radius: 50.0,
                            child: Icon(Icons.person,
                                size: 40.0, color: Colors.grey),
                          )),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '$followers',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          'followers',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          '$following',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          'following',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
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
                        ),
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
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            // Row(
            //   children: [
            //     const SizedBox(width: 40),
            //     ElevatedButton(
            //       onPressed: () async {
            //         setState(() {
            //           isFollowing = !isFollowing;
            //         });

            //         await supabase.from('profile').update({
            //           'followers': isFollowing ? followers + 1 : followers - 1,
            //         }).match({'user_id': athlete['uid']});

            //         await supabase.from('profile').update({
            //           'following': isFollowing ? following + 1 : following - 1,
            //         }).match({'user_id': uId});
            //       },
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: isFollowing ? Colors.black : Colors.white,
            //         backgroundColor: isFollowing ? Colors.white : Colors.blue,
            //         minimumSize: const Size(110.0, 36.0),
            //       ),
            //       child: Text(isFollowing ? 'Following' : 'Follow'),
            //     ),
            //     const SizedBox(width: 10),
            //     ElevatedButton(
            //       onPressed: () {},
            //       child: const Text('Message'),
            //     ),
            //   ],
            // ),
            // const VideoPlayerScreen(),
          ],
        ),
      ),
    );
  }
}
