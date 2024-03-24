import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteSearch extends StatefulWidget {
  const AthleteSearch({super.key});

  @override
  State<AthleteSearch> createState() => _AthleteSearchState();
}

class _AthleteSearchState extends State<AthleteSearch> {
  final supabase = Supabase.instance.client;
  final TextEditingController searchController = TextEditingController();
  dynamic athleteDetails;
  bool isLoading = false;
  List athletes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      athleteDetails = ModalRoute.of(context)?.settings.arguments as Map?;
      getData();
    });
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    athletes = await supabase
        .from('profile')
        .select()
        .ilike('name', '%${athleteDetails["searchText"]}%');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Search"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: isLoading
                      ? const Text('')
                      : athletes.isEmpty
                          ? const Text('No Athletes')
                          : ListView.builder(
                            itemCount: athletes.length,
                            itemBuilder: (context, index){
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
                                  backgroundColor: Colors.grey, // Placeholder color
                                  backgroundImage: athletes[index]['image_url'] != null
                                      ? NetworkImage(athletes[index]['image_url'])
                                      : null, // Prevent unnecessary widget creation
                                  child: athletes[index]['image_url'] == null
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
                                      Row(
                                        children: [
                                          Text(
                                            athletes[index]['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 60),
                                            child: IconButton(
                                              onPressed: () {},
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
                                            athletes[index]['dob'],
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
                                            athletes[index]['sport'] ?? '', // Use the null-aware operator (??)
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
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
                          ))
            ],
          ),
        ),
      ),
    );
  }
}
