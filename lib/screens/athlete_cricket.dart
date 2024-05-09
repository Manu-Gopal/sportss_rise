import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteCricket extends StatefulWidget {
  const AthleteCricket({super.key});

  @override
  State<AthleteCricket> createState() => _AthleteCricketState();
}

// ignore: constant_identifier_names
enum CricketPosition { Batsman, Bowler }

class _AthleteCricketState extends State<AthleteCricket> {
  CricketPosition? _selectedPosition;
  CricketPosition pos = CricketPosition.Batsman;

  final ImagePicker imagePicker = ImagePicker();
  dynamic imageFile;
  bool isUploading = false;
  final supabase = Supabase.instance.client;
  final uId = Supabase.instance.client.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
        title: const Text('Cricket', style: TextStyle(fontFamily: 'Poppins',),),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Choose Your Position',
              style: TextStyle(fontFamily: 'RobotoSlab',fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              title: const Text('Batsman'),
              leading: Radio<CricketPosition>(
                value: CricketPosition.Batsman,
                groupValue: _selectedPosition,
                onChanged: (CricketPosition? value) {
                  setState(() {
                    _selectedPosition = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Bowler'),
              leading: Radio<CricketPosition>(
                value: CricketPosition.Bowler,
                groupValue: _selectedPosition,
                onChanged: (CricketPosition? value) {
                  setState(() {
                    _selectedPosition = value;
                  });
                },
              ),
            ),
            isUploading
                ? const Text("Loading")
                : ElevatedButton(
                    onPressed: _selectedPosition != null
                        ? () async {
                            pos = _selectedPosition!;
                            uploadVideo();
                            await supabase.from('profile').update({
                              'sport': 'Cricket',
                              'position': pos.name
                            }).match({'user_id': uId});
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, '/athlete_main')
                .then((value) => setState(() => {}));
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPosition != null
                          ? Colors.green
                          : Colors.grey, // Set button color
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
      final videoName = supabase.auth.currentUser!.id + formattedDateTime;
      final String path = await supabase.storage
          .from('videos/cricket_videos')
          .upload(videoName, imageFile,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false));
      await supabase
          .from('videos')
          .insert({'user_id': supabase.auth.currentUser!.id, 'path': path});

      final String publicUrl = Supabase.instance.client.storage
          .from('videos')
          .getPublicUrl('cricket_videos/$videoName');

      await supabase
          .from('profile')
          .update({'video_url': publicUrl}).match({'user_id': uId});
    }
    setState(() {
      isUploading = false;
    });
  }
}
