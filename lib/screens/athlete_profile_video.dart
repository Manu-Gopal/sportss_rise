import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteProfileVideo extends StatefulWidget {
  const AthleteProfileVideo({super.key});

  @override
  State<AthleteProfileVideo> createState() => _AthleteProfileVideoState();
}

class _AthleteProfileVideoState extends State<AthleteProfileVideo> {

  final supabase = Supabase.instance.client;
  dynamic athleteProfile;
  bool isLoading = true;
  int followerCount = 0;
  int followingCount = 0;
  dynamic userEmail = Supabase.instance.client.auth.currentUser!.email!;
  dynamic uId = Supabase.instance.client.auth.currentUser!.id;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  dynamic imageUrl;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future getProfile() async {
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
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
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
                    Row(
                      children: [
                        Text(
                          '$followerCount',
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
                          '$followingCount',
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
                        athleteProfile[0]['name'],
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
                        userEmail,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/athlete_edit_profile');
                  },
                  icon: const Icon(Icons.edit, color: Colors.black,),
                  label: const Text('Edit Profile'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, '/');
                  },
                  label: const Text('Log Out'),
                  icon: const Icon(Icons.logout, color: Colors.black,),
                  
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
                    fontSize: 20
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

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final supabase = Supabase.instance.client;
  dynamic useremail = '';
  dynamic username = '';

  @override
  void initState() {
    super.initState();
    useremail = supabase.auth.currentUser!.email;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            accountEmail: Text(useremail,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            decoration: const BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: AssetImage('images/sai_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              // Navigator.pushNamed(context, '/visitor_bookings');
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const VisitorBookings()));
            },
            leading: const Icon(
              Icons.newspaper_outlined,
              color: Colors.black,
            ),
            title: const Text(
              "Latest News",
              style: TextStyle(
                  // fontFamily: 'RobotoSlab',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
