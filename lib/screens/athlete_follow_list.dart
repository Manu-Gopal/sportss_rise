import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteFollowList extends StatefulWidget {
  const AthleteFollowList({super.key});

  @override
  State<AthleteFollowList> createState() => _AthleteFollowListState();
}

class _AthleteFollowListState extends State<AthleteFollowList> {
  dynamic athlete;
  dynamic name;
  dynamic followerId;
  dynamic imageUrl;
  dynamic currentUser;
  dynamic athleteDetails;
  bool isLoading = true;
  List followedByList1 = [];
  dynamic followedByList;
  dynamic supabase = Supabase.instance.client;
  final List<Map<String, dynamic>> followedByUsernames = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      athlete = ModalRoute.of(context)?.settings.arguments as Map?;
      followerId = athlete['uid'];
      await getProfile();
    });
  }

  Future getProfile() async {
    athleteDetails =
        await supabase.from('follow').select('*').eq('follower', followerId);

    for (var i = 0; i < athleteDetails.length; i++) {
      String followedBy = athleteDetails[i]['followed_by'];
      followedByList1.add(followedBy);
    }

    currentUser = supabase.auth.currentUser!.id;

    setState(() {
      followedByList = athleteDetails;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
        title: const Text('Followers', style: TextStyle(fontFamily: 'Poppins'),),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getProfile();
          });
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 30),
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
              followedByList1.isEmpty
                  ? const Text('No followers', style: TextStyle(fontSize: 18, fontFamily: 'RobotoSlab'),)
                  :
                Center(
                  child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: followedByList1.length,
                    itemBuilder: (context, index) {
                      final String followedBy = followedByList1[index];
                
                      return FutureBuilder(
                        future: fetchUserDetails(followedBy),
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
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              userDetails['image_url'] != null
                                                  ? NetworkImage(
                                                      userDetails['image_url'])
                                                  : null,
                                          radius: 30,
                                          child: userDetails['image_url'] == null
                                              ? const Icon(Icons.person,
                                                  size: 40)
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            // ignore: use_build_context_synchronously
                                            // Navigator.pushNamed(
                                            //     context, '/chat_page',
                                            //     arguments: {
                                            //       'user_to': userDetails['user_id']
                                            //     });
                                          },
                                          child: Text(
                                            userDetails['name'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'RobotoSlab'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          }
                        },
                      );
                    },
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
