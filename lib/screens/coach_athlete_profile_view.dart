import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoachAthleteProfileView extends StatefulWidget {
  const CoachAthleteProfileView({super.key});

  @override
  State<CoachAthleteProfileView> createState() =>
      _CoachAthleteProfileViewState();
}

class _CoachAthleteProfileViewState extends State<CoachAthleteProfileView> {
  dynamic athleteList;
  dynamic coachSport;
  final supabase = Supabase.instance.client;
  dynamic coachId = Supabase.instance.client.auth.currentUser!.id;

  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAthletes();
  }

  Future getAthletes() async {
    coachSport = await supabase
        .from('coach_profile')
        .select('sport')
        .eq('coach_user_id', coachId);

    setState(() {
      isLoading = true;
    });

    final athleteStream = supabase
        .from('profile')
        .stream(primaryKey: ['id'])
        .eq('sport', coachSport[0]['sport'])
        .order('id');

    setState(() {
      athleteList = athleteStream;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SportsRise',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                  onTap: () {
                    if (searchController.text.isNotEmpty) {
                      Navigator.pushNamed(context, '/coach_athlete_search',
                          arguments: {'searchText': searchController.text});
                    }
                  },
                  child: const Icon(Icons.search),
                )),
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 55),
                  Expanded(
                    child: Text(
                      'Athletes',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder(
                  stream: athleteList,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final athleteList = snapshot.data!;
                      return ListView.builder(
                        itemCount: athleteList.length,
                        itemBuilder: (context, index) {
                          final athlete = athleteList[index];
                          return Card(
                            elevation: 9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/picture_view', arguments: {
                                        'imageUrl': athlete['image_url']
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: athlete['image_url'] !=
                                              null
                                          ? NetworkImage(athlete['image_url'])
                                          : null,
                                      child: athlete['image_url'] == null
                                          ? const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              athlete['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'RobotoSlab',
                                                fontSize: 20,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 60),
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(context,
                                                        '/coach_athlete_connect',
                                                        arguments: {
                                                          'uid': athlete[
                                                              'user_id'],
                                                          'videoUrl': athlete[
                                                              'video_url']
                                                        });
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .keyboard_arrow_right_outlined,
                                                    size: 35,
                                                    color: Colors.black,
                                                  )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              athlete['dob'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: 'RobotoSlab'),
                                            )
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Text(
                                        //       athlete['sport'] ?? '',
                                        //       style: const TextStyle(
                                        //           fontWeight: FontWeight.bold,
                                        //           fontSize: 15,
                                        //           fontFamily: 'RobotoSlab'),
                                        //     ),
                                        //     // if (athlete['accepted'] == true){

                                        //     // },
                                        //     const Padding(
                                        //       padding:
                                        //           EdgeInsets.only(left: 60),
                                        //       child: Icon(
                                        //         Icons.check,
                                        //         size: 30,
                                        //         color: Colors.green,
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        Row(
                                          children: [
                                            Text(
                                              athlete['sport'] ?? '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: 'RobotoSlab'),
                                            ),
                                            Visibility(
                                              visible: athlete['accepted'] ??
                                                  false,
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 60),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 25,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
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
