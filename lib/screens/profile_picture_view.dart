import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';  

class ProfilePictureView extends StatefulWidget {
  const ProfilePictureView({super.key});

  @override
  State<ProfilePictureView> createState() => _ProfilePictureViewState();
}

class _ProfilePictureViewState extends State<ProfilePictureView> {

  dynamic url;
  dynamic imageUrl;
  dynamic athleteProfile;
  bool isLoading = true;
  final supabase = Supabase.instance.client;
  dynamic uId = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      url = ModalRoute.of(context)?.settings.arguments as Map?;
      await getUrl();
    });
  }

  Future getUrl() async {
    imageUrl = url['imageUrl'];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Picture'),
      ),
      body: Center(
        child: isLoading ? const Text("Loading...")
        : imageUrl != null
          ? PhotoView(imageProvider: NetworkImage(imageUrl))
          : const Text('No Picture Available')
            // const Icon(Icons.person, size: 100, color: Colors.grey),
      ),
    );
  }
}