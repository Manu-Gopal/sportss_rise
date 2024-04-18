import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteCoachProfile extends StatefulWidget {
  const AthleteCoachProfile({super.key});

  @override
  State<AthleteCoachProfile> createState() => _AthleteCoachProfileState();
}

class _AthleteCoachProfileState extends State<AthleteCoachProfile> {
  dynamic supabase = Supabase.instance.client;
  final double profileHeight = 144;
  bool isLoading = true;

  dynamic uId;
  dynamic coach;
  dynamic imageUrl;
  dynamic publicUrl;
  dynamic coachName;
  dynamic coachSport;
  dynamic coachProfile;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      coach = ModalRoute.of(context)?.settings.arguments as Map?;
      uId = coach['user_id'];
      coachProfile = await supabase
          .from('coach_profile')
          .select()
          .match({'coach_user_id': uId});
      coachName = coachProfile[0]['name'];
      coachSport = coachProfile[0]['sport'];
      if (coachProfile[0]['image'] == true) {
        setState(() {
          imageUrl = coachProfile[0]['image_url'];
        });
      }
    });

    getCoachProfile();
  }

  Future getCoachProfile() async {
    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            onTap: () {
                              Navigator.pushNamed(context, '/picture_view',
                                  arguments: {
                                    'imageUrl': coachProfile[0]['image_url']
                                  });
                            },
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/picture_view',
                                        arguments: {'imageUrl': imageUrl});
                                  },
                                  child: CircleAvatar(
                                    radius: 70.0,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: imageUrl != null
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
                                          fontFamily: 'RobotoSlab',
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
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushNamed(context, '/chat_page',
                                        arguments: {'user_to': uId});
                                  },
                                  child: const Text('Message', style: TextStyle(fontSize: 20, fontFamily: 'RobotoSlab'),),
                                ),
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
  dynamic coachProfile;
  dynamic coachSport;
  dynamic coach;
  dynamic uId;
  dynamic url;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      coach = ModalRoute.of(context)?.settings.arguments as Map?;
      uId = coach['user_id'];
      coachSport = coach['sport'];
      coachProfile = await supabase
          .from('coach_profile')
          .select()
          .match({'coach_user_id': uId});
      // print(uId);
      await getCoachProfile();
    });
  }

  Future getCoachProfile() async {
    setState(() {
      if (coachSport == 'Football') {
        url = 'images/football_2BW.jpg';
      } else if (coachSport == 'Cricket') {
        url = 'images/cricket_2BW.jpg';
      } else if (coachSport == 'Badminton') {
        url = 'images/badminton_4.jpg';
      } else if (coachSport == 'Basketball') {
        url = 'images/basketball_5.png';
      } else if (coachSport == 'Swimming') {
        url = 'images/swim_4.png';
      } else {
        url = 'images/volley_1.jpg';
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: isLoading ? const Text("Loading...") : Image.asset(url),
      // SizedBox(
      //     width: 200, // Adjust the width to your desired fixed size
      //     height: 200, // Adjust the height to your desired fixed size
      //     child: Image.asset(url),
      //   ),
      // child: Image.network(),
      // width: double.infinity,
      // height: coverHeight,
      // fit: BoxFit.cover,
    );
  }
}
