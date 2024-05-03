import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddAchievement extends StatefulWidget {
  const AddAchievement({super.key});

  @override
  State<AddAchievement> createState() => _AddAchievementState();
}

class _AddAchievementState extends State<AddAchievement> {
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  dynamic imageFile;
  bool image = false;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    'Add Achievement',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 330,
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Type description here...',
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 11, 72, 103),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child:
                    const Text("Upload Image", style: TextStyle(fontSize: 18))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final supabase = Supabase.instance.client;
                String description = descriptionController.text;
                if (description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill description.'),
                    duration: Duration(seconds: 3),
                  ));
                  return;
                } else {
                  try {
                    if (imageFile != null) {
                      image = true;
                    }
                    final Map<String, dynamic> details = {
                      'user_id': Supabase.instance.client.auth.currentUser!.id,
                      'description': description,
                      'image': image,
                    };
                    final response = await supabase
                        .from('achievement')
                        .insert(details)
                        .select();
      
                    final int profileId = response[0]['id'];
      
                    if (imageFile != null) {
                      await Supabase.instance.client.storage
                          .from('images')
                          .upload(
                            'achievement_images/$profileId',
                            imageFile,
                            fileOptions: const FileOptions(
                                cacheControl: '3600', upsert: false),
                          );
                      final String publicUrl = Supabase.instance.client.storage
                          .from('images')
                          .getPublicUrl('achievement_images/$profileId');
      
                      await supabase.from('achievement').update(
                          {'image_url': publicUrl}).match({'id': profileId});
      
                      
                    }
                    // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Achievement Added Successfully.'),
                        duration: Duration(seconds: 3),
                      ));
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/athlete_profile');
                  } on PostgrestException catch (error) {
                    print(error.toString());
                    // if (error
                    //     .toString()
                    //     .contains('already registered')) {
                    //   // ignore: use_build_context_synchronously
                    //   ScaffoldMessenger.of(context)
                    //       .showSnackBar(const SnackBar(
                    //     content: Text(
                    //         'Email address already registered.'),
                    //     duration: Duration(seconds: 3),
                    //   ));
                    //   return;
                    // } else {
                    //   print(error.toString());
                    // }
                  }
                  //  catch (error) {
      
                  //   print(error.toString());
                  // }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 11, 72, 103),
                padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Robotoslab',
                  fontSize: 23.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
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
