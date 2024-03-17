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
    final athleteStream = supabase.from('profile')
      .stream(primaryKey: ['id'])
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
        title: const Text('Network'),
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
                      if (searchController.text.isNotEmpty){
                        Navigator.pushNamed(context,'/athlete_search', arguments: {
                          'searchText': searchController.text
                        });
                      }
                    },
                    child: const Icon(Icons.search),
                  )
                ),
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
                                  CircleAvatar(
                                    radius: 40.0,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: athlete['image_url'] != null
                                        ? NetworkImage(athlete['image_url'])
                                        : null,
                                    child: athlete['image_url'] == null
                                        ? const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              athlete['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 60),
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                  context, '/athlete_connect',
                                                  arguments: {
                                                    'uid': athlete['user_id'],
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_right_outlined,
                                                  size: 35,
                                                  color: Colors.black,
                                                )
                                              ),
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
                                              ),
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
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}
