import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaiCoaches extends StatefulWidget {
  const SaiCoaches({super.key});

  @override
  State<SaiCoaches> createState() => _SaiCoachesState();
}

class _SaiCoachesState extends State<SaiCoaches> {
  final TextEditingController searchController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool isLoading = false;
  dynamic coachList;
  List<String> sports = [
    'Cricket',
    'Football',
    'Volleyball',
    'Basketball',
    'Badminton',
    'Swimming'
  ];

  @override
  void initState() {
    super.initState();
    getCoaches();
  }

  Future getCoaches() async {
    setState(() {
      isLoading = true;
    });
    final coachStream =
        supabase.from('coach_profile').stream(primaryKey: ['id']).order('id');
    setState(() {
      coachList = coachStream;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SportsRise', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/sai_coach_search_page');
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            itemBuilder: (BuildContext context) {
              return sports.map((String sport) {
                return PopupMenuItem<String>(
                  value: sport,
                  child: Text(sport),
                );
              }).toList();
            },
            onSelected: (String selectedSport) {
              // Perform filtering based on the selected sport
              print('Filter by $selectedSport');
              // Add your filtering logic here
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextField(
              //   controller: searchController,
              //   decoration: InputDecoration(
              //       suffixIcon: GestureDetector(
              //     onTap: () {
              //       if (searchController.text.isNotEmpty) {
              //         Navigator.pushNamed(context, '/sai_coaches_search',
              //             arguments: {'searchText': searchController.text});
              //       }
              //     },
              //     child: const Icon(Icons.search),
              //   )),
              // ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 55),
                  Expanded(
                    child: Text(
                      'Coaches',
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
                  stream: coachList,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final coachList = snapshot.data!;
                      return ListView.builder(
                        itemCount: coachList.length,
                        itemBuilder: (context, index) {
                          final coach = coachList[index];
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
                                        'imageUrl': coach['image_url']
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          coach['image_url'] != null
                                              ? NetworkImage(coach['image_url'])
                                              : null,
                                      child: coach['image_url'] == null
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
                                              coach['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(context,
                                                        '/sai_coach_profile',
                                                        arguments: {
                                                          'user_id': coach[
                                                              'coach_user_id'],
                                                          'sport':
                                                              coach['sport']
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
                                              coach['sport'],
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_coach');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 231, 162, 87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20), // Adjust the value for circular edges
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24), // Adjust the padding for size
                ),
                child: const Text(
                  'Add Coach',
                  style: TextStyle(
                    color: Colors.white, // Set the text color
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
