import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteViewAchievement extends StatefulWidget {
  const AthleteViewAchievement({super.key});

  @override
  State<AthleteViewAchievement> createState() => _AthleteViewAchievementState();
}

class _AthleteViewAchievementState extends State<AthleteViewAchievement> {
  final supabase = Supabase.instance.client;
  dynamic athleteProfile;
  dynamic athleteAchievement;
  dynamic videoUrl;
  bool isLoading = true;
  int followerCount = 0;
  int followingCount = 0;
  dynamic accepted;
  dynamic userEmail = Supabase.instance.client.auth.currentUser!.email!;
  // dynamic uId = Supabase.instance.client.auth.currentUser!.id;
  dynamic uId;
  dynamic achievementDescription;
  dynamic achievementUrl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  dynamic imageUrl;
  dynamic userId;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      userId = ModalRoute.of(context)?.settings.arguments as Map?;
      uId = userId['userId'];

    getProfile();
    });
  }

  Future getProfile() async {
    athleteAchievement =
        await supabase.from('achievement').select().match({'user_id': uId});
    if (athleteAchievement.length>0) {
      achievementDescription = athleteAchievement[0]['description'];
      achievementUrl = athleteAchievement[0]['image_url'];
    }
    
    // achievementDescription = athleteAchievement[0]['description'];
    // achievementUrl = athleteAchievement[0]['image_url'];

    athleteProfile =
        await supabase.from('profile').select().match({'user_id': uId});
    final followerResponse =
        await supabase.from('follow').select('*').eq('follower', uId);
    followerCount = followerResponse.length;
    final followingResponse =
        await supabase.from('follow').select('*').eq('followed_by', uId);
    followingCount = followingResponse.length;

    setState(() {
      isLoading = true;
    });

    final id = athleteProfile[0]['id'];

    nameController.text = athleteProfile[0]['name'];
    phoneController.text = athleteProfile[0]['phone'];
    emailController.text = supabase.auth.currentUser!.email!;

    if (athleteProfile[0]['image'] == true) {
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
        title: const Text(
          'SportsRise',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
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
                              Navigator.pushNamed(
                                  context, '/athlete_follow_list',
                                  arguments: {'uid': uId});
                            },
                            child: Row(
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
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/athlete_following_list',
                                  arguments: {'uid': uId});
                            },
                            child: Row(
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
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            isLoading
                ? const Text("Loading...")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 60),
                      Text(
                        athleteProfile[0]['name'],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoSlab'),
                      ),
                      if (athleteProfile[0]['verified'])
                        IconButton(
                          icon: const Icon(Icons.verified),
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                    ],
                  ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              // Conditionally render the Row only if achievementUrl is not null
              children: achievementUrl != null
                  ? [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/picture_view',
                            arguments: {'imageUrl': achievementUrl},
                          );
                        },
                        child: Container(
                          width: 250.0,
                          height: 250.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                            image: achievementUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(achievementUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          // Show 'No Image Available' text only if imageUrl (presumably a local path) is null
                          child: achievementUrl == null
                              ? const Text(
                                  'No Image Available',
                                  style: TextStyle(fontFamily: 'RobotoSlab'),
                                )
                              : null,
                        ),
                      ),
                    ]
                  : const [], // Empty list if achievementUrl is null
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Text("Loading...")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Text(
                            achievementDescription ?? "No Achievements Added",
                        // athleteAchievement[0]['description'] ?? "",
                        style: const TextStyle(
                            fontFamily: 'RobotoSlab', fontSize: 22.0),
                        // overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      )),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
