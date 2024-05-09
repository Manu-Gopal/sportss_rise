import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteConnectVideo extends StatefulWidget {
  const AthleteConnectVideo({super.key});

  @override
  State<AthleteConnectVideo> createState() => _AthleteConnectVideoState();
}

class _AthleteConnectVideoState extends State<AthleteConnectVideo> {

  final supabase = Supabase.instance.client;
  dynamic userFrom;
  dynamic userTo;
  dynamic athlete;
  dynamic athleteDetails;
  dynamic follower;
  dynamic imageUrl;
  bool isLoading = true;
  bool isFollowing = false;

  final email = Supabase.instance.client.auth.currentUser!.email!;
  dynamic uId = Supabase.instance.client.auth.currentUser!.id;
  dynamic accountEmail;
  int followerCount = 0;
  int followingCount = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      athlete = ModalRoute.of(context)?.settings.arguments as Map?;
      follower = athlete['uid'];

      final res = await supabase
          .from('follow')
          .select('*')
          .eq('follower', follower)
          .eq('followed_by', uId);
      if (res.length > 0) {
        isFollowing = !isFollowing;
      }
      final followerResponse =
          await supabase.from('follow').select('*').eq('follower', follower);
      followerCount = followerResponse.length;
      final followingResponse =
          await supabase.from('follow').select('*').eq('followed_by', follower);
      followingCount = followingResponse.length;

      await getProfile();
    });
  }

  Future getProfile() async {
    athleteDetails = await supabase
        .from('profile')
        .select()
        .match({'user_id': athlete['uid']});
    final id = athleteDetails[0]['id'];
    userFrom = supabase.auth.currentUser!.id;
    userTo = athleteDetails[0]['user_id'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
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
                    fontFamily: 'Poppins'
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/picture_view',
                          arguments: {'imageUrl': imageUrl});
                    },
                    child: imageUrl != null
                        ? CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(imageUrl),
                          )
                        : const CircleAvatar(
                            radius: 50.0,
                            child: Icon(Icons.person,
                                size: 40.0, color: Colors.grey),
                          ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/athlete_follow_list',
                            arguments: {
                              'uid': athlete['uid']
                            });
                      },
                      child: Row(
                        children: [
                          Text(
                            '$followerCount',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoSlab'
                            ),
                          ),
                          const SizedBox(width: 7),
                          const Text(
                            'followers',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoSlab'
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/athlete_following_list',
                            arguments: {
                              'uid': athlete['uid']
                            });
                      },
                      child: Row(
                        children: [
                          Text(
                            '$followingCount',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoSlab'
                            ),
                          ),
                          const SizedBox(width: 7),
                          const Text(
                            'following',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoSlab'
                            ),
                          ),
                        ],
                      ),
                    )
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
                          fontFamily: 'RobotoSlab'
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
                          fontFamily: 'RobotoSlab'
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 40),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isFollowing = !isFollowing;
                      isFollowing?followerCount += 1 : followerCount -=1;

                    });
                    if (isFollowing) {
                      await supabase
                          .from('follow')
                          .insert({'follower': follower, 'followed_by': uId});
                    } else {
                      await supabase
                          .from('follow')
                          .delete()
                          .eq('follower', follower)
                          .eq('followed_by', uId);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isFollowing ? Colors.black : Colors.white,
                    backgroundColor: isFollowing ? Colors.white : Colors.blue,
                    minimumSize: const Size(110.0, 36.0),
                  ),
                  child: Text(isFollowing ? 'Following' : 'Follow', style: const TextStyle(fontFamily: 'RobotoSlab'),),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {

                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, '/chat_page',
                        arguments: {'user_to': follower});
                  },
                  child: const Text('Message', style: TextStyle(fontFamily: 'RobotoSlab'),),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Video Available',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'RobotoSlab'
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}