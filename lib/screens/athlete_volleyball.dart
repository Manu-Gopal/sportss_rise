import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteVolleyball extends StatefulWidget {
  const AthleteVolleyball({super.key});

  @override
  State<AthleteVolleyball> createState() => _AthleteVolleyballState();
}

class _AthleteVolleyballState extends State<AthleteVolleyball> {
  final ImagePicker imagePicker = ImagePicker();
  dynamic imageFile;
  bool isUploading = false;
  final supabase = Supabase.instance.client;
  final uId = Supabase.instance.client.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volleyball', style: TextStyle(fontFamily: 'Poppins'),),
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
                                  .update({'sport': 'Volleyball'}).match(
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
                          fontFamily: 'RobotoSlab',
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
      final videoName = supabase.auth.currentUser!.id + formattedDateTime;
      final String path = await supabase.storage
          .from('videos/volleyball_videos')
          .upload(
              videoName, imageFile,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false));
      await supabase
          .from('videos')
          .insert({'user_id': supabase.auth.currentUser!.id, 'path': path});
      final String publicUrl = Supabase
                                  .instance.client.storage
                                  .from('videos')
                                  .getPublicUrl('swimming_videos/$videoName');
      await supabase.from('profile').update({'video_url':publicUrl}).match({'user_id':uId});
    }
    setState(() {
      isUploading = false;
    });
  }
}
