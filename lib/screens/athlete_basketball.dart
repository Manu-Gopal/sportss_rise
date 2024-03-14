import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteBasketball extends StatefulWidget {
  const AthleteBasketball({super.key});

  @override
  State<AthleteBasketball> createState() => _AthleteBasketballState();
}

class _AthleteBasketballState extends State<AthleteBasketball> {
  final ImagePicker imagePicker = ImagePicker();
  dynamic imageFile;
  bool isUploading = false;
  final supabase = Supabase.instance.client;
  final uId = Supabase.instance.client.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basketball'),
      ),
      body: Center(
        child: Column(
          children: [
            isUploading
                ? const Text("Uploading")
                : ElevatedButton(
                    onPressed: () async {
                      uploadVideo();
                      Navigator.pushNamed(context,
                            '/athlete_main');
                            await supabase
                                  .from('profile')
                                  .update({'sport': 'Basketball'}).match(
                                      {'user_id': uId});
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                    child: const Text(
                      'Upload Video',
                      style: TextStyle(
                          fontSize: 20,
                          //fontFamily: 'NovaSquare',
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
          ],
        ),
      ),
    );
  }

  Future uploadVideo() async {
    setState(() {
      isUploading = true;
    });
    String formattedDateTime =
        DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    final pickedImage =
        await imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imagePath = pickedImage.path;
      setState(() {
        imageFile = File(imagePath);
      });
      final String path = await supabase.storage
          .from('videos/basketball_videos')
          .upload(
              supabase.auth.currentUser!.id + formattedDateTime, imageFile,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false));
      await supabase
          .from('videos')
          .insert({'user_id': supabase.auth.currentUser!.id, 'path': path});
    }
    setState(() {
      isUploading = false;
    });
  }
}
