import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteNetwork extends StatefulWidget {
  const AthleteNetwork({super.key});

  @override
  State<AthleteNetwork> createState() => _AthleteNetworkState();
}

class _AthleteNetworkState extends State<AthleteNetwork> {
  dynamic athleteList;
  final supabase = Supabase.instance.client;
  dynamic userId = Supabase.instance.client.auth.currentUser!.id;

  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAthletes();
  }

  Future getAthletes() async {
    setState(() {
      isLoading = true;
    });
    final athleteStream = supabase
        .from('profile')
        .stream(primaryKey: ['id']).order('follower_count', ascending: false);

    setState(() {
      athleteList = athleteStream;
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
        actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                // Action to perform when the message icon is pressed
                Navigator.pushNamed(context, '/athlete_message_list');
              },
            ),
          ],
      ),
      // drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getAthletes();
          });
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      hintText: 'Search by name or sport',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (searchController.text.isNotEmpty) {
                            Navigator.pushNamed(context, '/athlete_search',
                                arguments: {
                                  'searchText': searchController.text
                                });
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
                        'Athlete Connect',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Poppins'),
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
                                            context, '/picture_view',
                                            arguments: {
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
                                                    fontSize: 20,
                                                    fontFamily: 'RobotoSlab'),
                                              ),
                                              if (athlete['verified'])
                                                IconButton(
                                                  icon: const Icon(Icons.verified),
                                                  color: Colors.blue,
                                                  onPressed: () {
                                                    // Handle onPressed action
                                                  },
                                                ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                athlete['dob'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: 'RobotoSlab',
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 42),
                                                child: IconButton(
                                                    onPressed: () {
                                                      if (athlete['user_id'] ==
                                                          userId) {
                                                              // Navigator.pushNamed(
                                                              // context,
                                                              // '/athlete_profile');
                                                        if (athlete[
                                                                'video_url'] !=
                                                            null) {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/athlete_profile');
                                                        } else {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/athlete_profile_video');
                                                        }
                                                      } else {
                                                        if (athlete[
                                                                'video_url'] ==
                                                            null) {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/athlete_connect_video',
                                                              arguments: {
                                                                'uid': athlete[
                                                                    'user_id'],
                                                              });
                                                        } else {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/athlete_connect',
                                                              arguments: {
                                                                'uid': athlete[
                                                                    'user_id'],
                                                                'videoUrl': athlete[
                                                                    'video_url']
                                                              });
                                                        }
                                                      }
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
                                                athlete['sport'] ?? '',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: 'RobotoSlab'),
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
