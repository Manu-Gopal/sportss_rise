import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoachMessageList extends StatefulWidget {
  const CoachMessageList({super.key});

  @override
  State<CoachMessageList> createState() => _CoachMessageListState();
}

class _CoachMessageListState extends State<CoachMessageList> {
  final supabase = Supabase.instance.client;
  dynamic userId = Supabase.instance.client.auth.currentUser!.id;
  List messageList = [];
  bool isLoading = false;
  dynamic messageStream1;
  dynamic messageStream2;
  dynamic athleteList;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  Future getMessages() async {
    setState(() {
      isLoading = true;
    });
    messageStream1 =
        await supabase.from('messages').select('*').eq('profile_id', userId);
    for (var i = 0; i < messageStream1.length; i++) {
      String msgList = messageStream1[i]['user_to'];
      messageList.add(msgList);
    }
    messageStream2 =
        await supabase.from('messages').select('*').eq('user_to', userId);
    for (var i = 0; i < messageStream2.length; i++) {
      String msgList = messageStream2[i]['profile_id'];
      if (!messageList.contains(msgList)) {
        messageList.add(msgList);
      }
    }
    athleteList = await supabase.from('profile').select();
    for (var i = 0; i < athleteList.length; i++) {
      String athleteId = athleteList[i]['user_id'];
      if (messageList.contains(athleteId)) {
        messageList.remove(athleteId);
      }
    }
    setState(() {
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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getMessages();
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
                      'Coach Messages',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              messageList.isEmpty
                  ? const Text(
                      'No Messages',
                      style: TextStyle(fontSize: 18, fontFamily: 'RobotoSlab'),
                    )
                  : Center(
                      child: Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: messageList.length,
                          itemBuilder: (context, index) {
                            final String uId = messageList[index];

                            return FutureBuilder(
                              future: fetchUserDetails(uId),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Map<String, dynamic>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final details = snapshot.data!;
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
                                              details['image_url'] != null
                                                  ? NetworkImage(
                                                      details['image_url'])
                                                  : null,
                                          radius: 30,
                                          child: details['image_url'] == null
                                              ? const Icon(Icons.person,
                                                  size: 40)
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushNamed(
                                                context, '/chat_page',
                                                arguments: {
                                                  'user_to': details['coach_user_id']
                                                });
                                          },
                                          child: Text(
                                            details['name'],
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
        .from('coach_profile')
        .select('*')
        .eq('coach_user_id', userId)
        .single()
        .execute();
  } catch (error) {
    print(error.toString());
  }
  return response.data as Map<String, dynamic>;
}
