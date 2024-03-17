import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteConnect extends StatefulWidget {
  const AthleteConnect({super.key});

  @override
  State<AthleteConnect> createState() => _AthleteConnectState();
}

class _AthleteConnectState extends State<AthleteConnect> {
  final supabase = Supabase.instance.client;
  dynamic athlete;
  dynamic athleteDetails;
  dynamic nam;
  // dynamic em;
  bool isLoading = true;
  final email = Supabase.instance.client.auth.currentUser!.email!;
  dynamic uId = Supabase.instance.client.auth.currentUser!.id;
  dynamic accountEmail;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  dynamic imageUrl;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   Future.delayed(Duration.zero, () {
  //     print('blaablaaa');
  //     athlete = ModalRoute.of(context)?.settings.arguments as Map?;
  //     print(athlete['user_id']);
  //     await getProfile();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      athlete = ModalRoute.of(context)?.settings.arguments as Map?;
      getProfile();
      
    });
  }

  Future getProfile() async {
    athleteDetails = await supabase
        .from('profile')
        .select()
        .match({'user_id': athlete['uid']});
    final id = athleteDetails[0]['id'];
    final supabase1 = SupabaseClient(dotenv.env['URL']!, dotenv.env['SECRET_KEY']!);

    
    final res = await supabase1.auth.admin.getUserById(athleteDetails[0]['user_id']);

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                const Column(
                  children: [
                    Text(
                      'Followers: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Following: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading?const Text("Loading..."): Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  athleteDetails[0]['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            isLoading?const Text("Loading..."): Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  accountEmail,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
