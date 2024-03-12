import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteNetwork extends StatefulWidget {
  const AthleteNetwork({super.key});

  @override
  State<AthleteNetwork> createState() => _AthleteNetworkState();
}

class _AthleteNetworkState extends State<AthleteNetwork> {
  final athleteList = Supabase.instance.client
      .from('profile')
      .stream(primaryKey: ['id'])
      .order('id');
  final supabase = Supabase.instance.client;
  dynamic userId = Supabase.instance.client.auth.currentUser!.id;

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
    // exhibitions = await supabase.from('ex_manager').select();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                                    backgroundColor: Colors.grey, // Placeholder color
                                    backgroundImage: athlete['image_url'] != null
                                        ? NetworkImage(athlete['image_url'])
                                        : null, // Prevent unnecessary widget creation
                                    child: athlete['image_url'] == null
                                        ? const Icon(
                                            Icons.person, // Customizable icon
                                            color: Colors.white,
                                          )
                                        : null, // Don't display icon if image URL is available
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          athlete['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        // Add other athlete information here
                                        // (e.g., sport, bio, etc.) if available in the data
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
