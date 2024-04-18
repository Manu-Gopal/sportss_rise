import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteCoachSearch extends StatefulWidget {
  const AthleteCoachSearch({super.key});

  @override
  State<AthleteCoachSearch> createState() => _AthleteCoachSearchState();
}

class _AthleteCoachSearchState extends State<AthleteCoachSearch> {
  final supabase = Supabase.instance.client;

  dynamic coachDetails;
  bool isLoading = true;
  // dynamic coachList;
  List coaches = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      coachDetails = ModalRoute.of(context)?.settings.arguments as Map?;
      getData();
    });
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    coaches = await supabase
        .from('coach_profile')
        .select()
        .ilike('name', '%${coachDetails["searchText"]}%');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blueAccent,
        title: const Text("Search", style: TextStyle(fontFamily: 'Poppins'),),
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
        // centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/sai_coach_search')
                .then((value) => setState(() => {}));
          },
        ),
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
                      : coaches.isEmpty
                          ? const Text('No Coaches', style: TextStyle(fontFamily: 'RobotoSlab'),)
                          : ListView.builder(
                              itemCount: coaches.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 9,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/picture_view',
                                                arguments: {
                                                  'imageUrl': coaches[index]
                                                      ['image_url']
                                                });
                                          },
                                          child: CircleAvatar(
                                            radius: 40.0,
                                            backgroundColor: Colors.grey,
                                            backgroundImage: coaches[index]
                                                        ['image_url'] !=
                                                    null
                                                ? NetworkImage(
                                                    coaches[index]['image_url'])
                                                : null,
                                            child: coaches[index]
                                                        ['image_url'] ==
                                                    null
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
                                                    coaches[index]['name'],
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
                                                            left: 55),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/sai_coach_profile',
                                                              arguments: {
                                                                'user_id': coaches[
                                                                        index][
                                                                    'coach_user_id'],
                                                                'sport': coaches[
                                                                        index]
                                                                    ['sport']
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
                                                    coaches[index]['sport'] ??
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
