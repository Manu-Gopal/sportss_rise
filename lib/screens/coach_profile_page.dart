import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoachProfilePage extends StatefulWidget {
  const CoachProfilePage({super.key});

  @override
  State<CoachProfilePage> createState() => _CoachProfilePageState();
}

class _CoachProfilePageState extends State<CoachProfilePage> {
  dynamic supabase = Supabase.instance.client;
  dynamic coachUserId = Supabase.instance.client.auth.currentUser!.id;
  final double profileHeight = 144;
  bool isLoading = true;

  dynamic imageUrl;
  dynamic publicUrl;
  dynamic coachName;
  dynamic coachSport;
  dynamic coachProfile;

  @override
  void initState() {
    super.initState();
    getCoachProfile();
  }

  Future getCoachProfile() async {
    setState(() {
      isLoading = true;
    });
    coachProfile = await supabase
        .from('coach_profile')
        .select()
        .match({'coach_user_id': coachUserId});
    coachName = coachProfile[0]['name'];
    coachSport = coachProfile[0]['sport'];
    if(coachSport=='Football'){

    }

    setState(() {
      // coachName = coachProfile[0]['name'];
      // coachSport = coachProfile[0]['sport'];
      isLoading = false;
    });

    if (coachProfile[0]['image'] == true) {
      setState(() {
        imageUrl = coachProfile[0]['image_url'];
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
        title: const Text('Profile', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const CustomDrawer(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const BuildCoverImage(),
              // const SizedBox(height: 100,),
              Positioned(
                top: 280,
                child: isLoading
                    ? const Text("Loading...")
                    : (imageUrl != null)
                        ? GestureDetector(
                            child: Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/picture_view', arguments: {
                                        'imageUrl': imageUrl
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 70.0,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          imageUrl != null
                                              ? NetworkImage(imageUrl)
                                              : null,
                                      child: imageUrl == null
                                          ? const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                                const SizedBox(
                                    height:
                                        14), // Add some space between CircleAvatar and Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$coachName',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$coachSport Coach',
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class BuildCoverImage extends StatefulWidget {
  const BuildCoverImage({super.key});

  @override
  State<BuildCoverImage> createState() => _BuildCoverImageState();
}

class _BuildCoverImageState extends State<BuildCoverImage> {

  final double coverHeight = 280;
  dynamic supabase = Supabase.instance.client;
  dynamic coachUserId = Supabase.instance.client.auth.currentUser!.id;
  dynamic coachProfile;
  dynamic coachSport;
  dynamic url;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCoachProfile();
  }

  Future getCoachProfile() async{
    coachProfile = await supabase
        .from('coach_profile')
        .select()
        .match({'coach_user_id': coachUserId});
    setState(() {
      
    coachSport = coachProfile[0]['sport'];
    if(coachSport=='Football'){
      url = 'images/football_2BW.jpg';
    } else if(coachSport=='Cricket'){
      url = 'images/cricket_2BW.jpg';
    } else if(coachSport=='Badminton'){
      url = 'images/badminton_4.jpg';
    } else if(coachSport=='Basketball'){
      url = 'images/basketball_5.png';
    } else if(coachSport=='Swimming'){
      url = 'images/swim_4.png';
    } else{
      url = 'images/volley_1.jpg';
    }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: isLoading
                      ? const Text("Loading..."):
      Image.asset(url),
      // child: Image.network(),
      // width: double.infinity,
      // height: coverHeight,
      // fit: BoxFit.cover,
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
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, '/');
            },
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.black,
            ),
            title: const Text(
              "Log Out",
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