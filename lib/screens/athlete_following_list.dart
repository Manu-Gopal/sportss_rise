import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteFollowingList extends StatefulWidget {
  const AthleteFollowingList({super.key});

  @override
  State<AthleteFollowingList> createState() => _AthleteFollowingListState();
}

class _AthleteFollowingListState extends State<AthleteFollowingList> {
  dynamic athlete;
  dynamic name;
  dynamic followingId;
  dynamic imageUrl;
  dynamic currentUser;
  dynamic athleteDetails;
  bool isLoading = true;
  List followingList1 = [];
  dynamic followingList;
  dynamic supabase = Supabase.instance.client;
  final List<Map<String, dynamic>> followedByUsernames = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      athlete = ModalRoute.of(context)?.settings.arguments as Map?;
      followingId = athlete['uid'];
      await getProfile();
    });
  }

  Future getProfile() async {
    athleteDetails =
        await supabase.from('follow').select('*').eq('followed_by', followingId);

    for (var i = 0; i < athleteDetails.length; i++) {
      String following = athleteDetails[i]['follower'];
      followingList1.add(following);
    }

    currentUser = supabase.auth.currentUser!.id;

    setState(() {
      followingList = athleteDetails;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
        title: const Text('Following'),
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
                      'Athletes',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Poppins'
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: followingList1.length,
                  itemBuilder: (context, index) {
                    final String following = followingList1[index];

                    return FutureBuilder(
                      future: fetchUserDetails(following),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final userDetails = snapshot.data!;
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      Colors.grey),
                              borderRadius: BorderRadius.circular(
                                  5.0), 
                            ),
                            child: Text(userDetails[
                                'name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'RobotoSlab')), 
                          );
                        }
                      },
                    );
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

Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
  dynamic supabase = Supabase.instance.client;
  dynamic response;
  try {
    response = await supabase
        .from('profile')
        .select('*')
        .eq('user_id', userId)
        .single()
        .execute();
  } catch (error) {
    print(error.toString());
  }
  return response.data as Map<String, dynamic>;
}