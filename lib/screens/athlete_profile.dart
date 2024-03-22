import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteProfile extends StatefulWidget {
  const AthleteProfile({super.key});

  @override
  State<AthleteProfile> createState() => _AthleteProfileState();
}

class _AthleteProfileState extends State<AthleteProfile> {
  final supabase = Supabase.instance.client;
  // ignore: non_constant_identifier_names
  dynamic athlete_profile;
  bool isLoading = false;
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
    setState(() {
      isLoading = true;
    });

    athlete_profile =
        await supabase.from('profile').select().match({'user_id': uId});
    final id = athlete_profile[0]['id'];

    nameController.text = athlete_profile[0]['name'];
    phoneController.text = athlete_profile[0]['phone'];
    emailController.text = supabase.auth.currentUser!.email!;

    if (athlete_profile[0]['image'] == true) {
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

  Widget textFields(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0, // Adjust the left padding as needed
      ),
      child: TextField(
        controller: controller,
        enabled: false,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 80),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context, '/profile_picture_view',
                  arguments: {
                    'imageUrl': imageUrl
                  }
                );
              },
              child: imageUrl != null
                  ? CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(imageUrl),
                    )
                  : const CircleAvatar(
                      radius: 50.0,
                      child: Icon(Icons.person, size: 40.0, color: Colors.grey),
                    ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      const Text('   Name'),
      textFields(nameController),
      const SizedBox(height: 15),
      const Text("   Phone Number"),
      textFields(phoneController),
      const SizedBox(height: 15),
      const Text("   Email"),
      textFields(emailController),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                elevation: MaterialStateProperty.all(3),
                backgroundColor: MaterialStateProperty.all(Colors.grey),
              ),
              onPressed: () async {
                Navigator.pushNamed(context, '/athlete_edit_profile');
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.edit, color: Colors.black),
                        SizedBox(
                            width: 8.0), // Adjust spacing between icon and text
                        Text(
                          'Edit Details',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                elevation: MaterialStateProperty.all(3),
                backgroundColor: MaterialStateProperty.all(
                    Colors.grey), // Set the background color here
              ),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, '/');
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.black,
                        // fontFamily: 'RobotoSlab',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.logout, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ]);
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
