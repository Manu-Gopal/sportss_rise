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
  final TextEditingController descriptionController = TextEditingController();

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
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
        title: const Text(
          'Football',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Choose Your Position',
              style: TextStyle(fontFamily: 'RobotoSlab', fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              title: const Text(
                'Forward',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                ),
              ),
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
              title: const Text(
                'Midfield',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                ),
              ),
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
              title: const Text(
                'Defender',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                ),
              ),
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
              title: const Text(
                'Goalkeeper',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                ),
              ),
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
            const Row(
              children: [
                Center(
                  child: Text(
                    'Add Achievements (if any)',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Poppins'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Type description here...',
                labelText: 'Description',
                // prefixIcon: Icon(
                //   Icons.mail,
                //   color: Color.fromARGB(255, 78, 66, 66),
                // ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (imageFile != null)
              Image.file(
                File(imageFile!.path),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ElevatedButton(
                onPressed: () {
                  uploadImage();
                },
                child: const Text("Upload Image")),
            isUploading
                ? const Text("Loading")
                : ElevatedButton(
                    onPressed: _selectedPosition != null
                        ? () async {
                            String description = descriptionController.text;
                            pos = _selectedPosition!;
                            uploadVideo();
                            // ignore: unnecessary_null_comparison
                            if (description == '' && imageFile != null) {
                              await supabase.from('profile').update({
                                'sport': 'Football',
                                'position': pos.name
                              }).match({'user_id': uId});
                            } else {
                              await supabase.from('profile').update({
                                'sport': 'Football',
                                'position': pos.name,
                                'achievement_image': true,
                              }).match({'user_id': uId});
                              
                              final String profileId =  await supabase.from('profile').select('id').match({'user_id':uId});
                              if (imageFile != null) {
                                await Supabase.instance.client.storage
                                    .from('achievement')
                                    .upload(
                                      'achievement_images/$profileId',
                                      imageFile,
                                      fileOptions: const FileOptions(
                                          cacheControl: '3600', upsert: false),
                                    );
                                  final String publicUrl = Supabase
                                  .instance.client.storage
                                  .from('images')
                                  .getPublicUrl('achievement_images/$profileId');

                                  await supabase
                                  .from('profile')
                                  .update({'achievement_image_url': publicUrl}).match(
                                      {'id': profileId});
                                }
                            }

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Details Updated Successfully.'),
                              duration: Duration(seconds: 3),
                            ));
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, '/athlete_main');
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
                          fontFamily: 'RobotoSlab',
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
          .from('videos/football_videos')
          .upload(videoName, imageFile,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false));

      await supabase
          .from('videos')
          .insert({'user_id': supabase.auth.currentUser!.id, 'path': path});

      final String publicUrl = Supabase.instance.client.storage
          .from('videos')
          .getPublicUrl('football_videos/$videoName');
      await supabase
          .from('profile')
          .update({'video_url': publicUrl}).match({'user_id': uId});
    }
    setState(() {
      isUploading = false;
    });
  }

  Future uploadImage() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imagePath = pickedImage.path;
      setState(() {
        imageFile = File(imagePath);
      });
    }
  }
}
