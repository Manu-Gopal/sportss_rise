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
        // .ilike('name', '%${athleteDetails["searchText"]}%');
        .or('name.ilike.%${athleteDetails["searchText"]}%, sport.ilike.%${athleteDetails["searchText"]}%');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
        title: const Text("Search", style: TextStyle(fontFamily: 'Poppins'),),
        // centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/athlete_athlete_search_page')
        //         .then((value) => setState(() => {}));
        //   },
        // ),
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
                          ? const Text('No Athletes', style: TextStyle(fontFamily: 'RobotoSlab'),)
                          : ListView.builder(
                              itemCount: athletes.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 9,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 40.0,
                                          backgroundColor:
                                              Colors.grey, // Placeholder color
                                          backgroundImage: athletes[index]
                                                      ['image_url'] !=
                                                  null
                                              ? NetworkImage(
                                                  athletes[index]['image_url'])
                                              : null, // Prevent unnecessary widget creation
                                          child: athletes[index]['image_url'] ==
                                                  null
                                              ? const Icon(
                                                  Icons
                                                      .person, // Customizable icon
                                                  color: Colors.white,
                                                )
                                              : null, // Don't display icon if image URL is available
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
                                                    athletes[index]['name'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      fontFamily: 'RobotoSlab'
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: IconButton(
                                                        onPressed: () {},
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
                                                    athletes[index]['dob'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      fontFamily: 'RobotoSlab'
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    athletes[index]['sport'] ??
                                                        '',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      fontFamily: 'RobotoSlab'
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
                            ))
            ],
          ),
        ),
      ),
    );
  }
}
