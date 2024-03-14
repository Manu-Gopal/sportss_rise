import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteFootball extends StatefulWidget {
  const AthleteFootball({super.key});

  @override
  State<AthleteFootball> createState() => _AthleteFootballState();
}

// ignore: constant_identifier_names
enum FootballPosition { Forward, Midfielder, Defender, Goalkeeper }

class _AthleteFootballState extends State<AthleteFootball> {
  FootballPosition? _selectedPosition;
  FootballPosition pos = FootballPosition.Forward;

  final ImagePicker imagePicker = ImagePicker();
  dynamic imageFile;
  bool isUploading = false;
  final supabase = Supabase.instance.client;
  final uId = Supabase.instance.client.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Choose Your Position',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              title: const Text('Forward'),
              leading: Radio<FootballPosition>(
                value: FootballPosition.Forward,
                groupValue: _selectedPosition,
                onChanged: (FootballPosition? value) {
                  setState(() {
                    _selectedPosition = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Midfield'),
              leading: Radio<FootballPosition>(
                value: FootballPosition.Midfielder,
                groupValue: _selectedPosition,
                onChanged: (FootballPosition? value) {
                  setState(() {
                    _selectedPosition = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Defender'),
              leading: Radio<FootballPosition>(
                value: FootballPosition.Defender,
                groupValue: _selectedPosition,
                onChanged: (FootballPosition? value) {
                  setState(() {
                    _selectedPosition = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Goalkeeper'),
              leading: Radio<FootballPosition>(
                value: FootballPosition.Goalkeeper,
                groupValue: _selectedPosition,
                onChanged: (FootballPosition? value) {
                  setState(() {
                    _selectedPosition = value;
                  });
                },
              ),
            ),
            isUploading
                ? const Text("Loading")
                : ElevatedButton(
                    onPressed: _selectedPosition != null ? () async {
                      pos = _selectedPosition!;
                      uploadVideo();
                      Navigator.pushNamed(context,
                            '/athlete_main');
                            await supabase
                                  .from('profile')
                                  .update({'sport': 'Football', 'position' : pos.name}).match(
                                      {'user_id': uId});
                          
                    } : null,
                    style: ElevatedButton.styleFrom(
                backgroundColor: _selectedPosition != null ? Colors.green : Colors.grey, // Set button color
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
          .from('videos/football_videos')
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
