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
  List followingList = [];
  dynamic supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      athlete = ModalRoute.of(context)?.settings.arguments as Map?;
      followingId = athlete['uid'];
      print(followingId);
      await getProfile();
    });
  }

  Future getProfile() async {
    athleteDetails =
        await supabase.from('follow').select().eq('followed_by', followingId);
    for (Map<String, dynamic> athlete in athleteDetails) {
      if (athlete.containsKey('followed_by')) {
        followingList.add(athlete['followed_by']);
      }
    }
    print(followingList);

    // videoUrl = athlete['videoUrl'];
    // final id = athleteDetails[0]['id'];
    currentUser = supabase.auth.currentUser!.id;
    // userTo = athleteDetails[0]['user_id'];
    // final supabase1 =
    //     SupabaseClient(dotenv.env['URL']!, dotenv.env['SECRET_KEY']!);

    // final res =
    //     await supabase1.auth.admin.getUserById(athleteDetails[0]['user_id']);

    // accountEmail = res.user!.email;
    // if (athleteDetails[0]['image'] == true) {
    //   final String publicUrl = Supabase.instance.client.storage
    //       .from('images')
    //       .getPublicUrl('item_images/$id');

    //   setState(() {
    //     imageUrl = publicUrl;
    //   });
    // }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      // body: ,
    );
  }
}
