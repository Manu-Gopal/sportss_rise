import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteSwimming extends StatefulWidget {
  const AthleteSwimming({super.key});

  @override
  State<AthleteSwimming> createState() => _AthleteSwimmingState();
}

class _AthleteSwimmingState extends State<AthleteSwimming> {
  final ImagePicker imagePicker = ImagePicker();
  dynamic imageFile;
  bool isUploading = false;
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swimming'),
      ),
      body: Center(
        child: Column(
          children: [
            isUploading
                ? const Text("Uploading")
                : ElevatedButton(
                    onPressed: () {
                      uploadVideo();
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
          .from('videos/swimming_videos')
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