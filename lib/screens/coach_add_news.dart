import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CoachAddNews extends StatefulWidget {
  const CoachAddNews({super.key});

  @override
  State<CoachAddNews> createState() => _CoachAddNewsState();
}

class _CoachAddNewsState extends State<CoachAddNews> {
  dynamic imageFile;
  dynamic imageUrl;
  bool image = false;
  final ImagePicker imagePicker = ImagePicker();

  final supabase = Supabase.instance.client;
  final newsHeadlineController = TextEditingController(); // Text field controller
  final newsDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add News'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Add News',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40), // Adjust spacing as needed
              TextField(
                controller: newsHeadlineController, // Link controller to text field
                decoration: const InputDecoration(
                  labelText: 'Headline',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.multiline,
                controller: newsDescriptionController, // Link controller to text field
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
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
                child: const Text('Upload Picture'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final supabase = Supabase.instance.client;
                  String newsHeadline = newsHeadlineController.text;
                  String description = newsDescriptionController.text;

                  if (newsHeadline.isEmpty || description.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please fill all details.'),
                      duration: Duration(seconds: 3),
                    ));
                    return;
                  } else {
                    try {
                      if (imageFile != null) {
                        image = true;
                      }

                      final Map<String, dynamic> newsDetails = {
                        'headline': newsHeadline,
                        'description': description,
                        'image': image
                      };

                      final response = await supabase
                          .from('news')
                          .insert(newsDetails)
                          .select();

                      final int newsId = response[0]['id'];

                      if (imageFile != null) {
                        await Supabase.instance.client.storage
                            .from('images')
                            .upload(
                              'news_images/$newsId',
                              imageFile,
                              fileOptions: const FileOptions(
                                  cacheControl: '3600', upsert: false),
                            );

                        final String imageUrl = Supabase.instance.client.storage
                            .from('images')
                            .getPublicUrl('news_images/$newsId');

                        await supabase.from('news').update(
                            {'image_url': imageUrl}).match({'id': newsId});
                      }
                    } on PostgrestException catch (error) {
                      if (error.toString().contains('already registered')) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Email address already registered.'),
                          duration: Duration(seconds: 3),
                        ));
                        return;
                      } else {
                        // Handle other potential Postgrest errors (optional)
                        // print('Signup error: ${error.toString()}');
                        // You can choose to display a generic error message here
                      }
                    } catch (error) {
                      // Handle other potential errors (optional)
                      // print('Unexpected error: $error');
                      // You can choose to display a generic error message here
                    }
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('News Added Successfully.'),
                      duration: Duration(seconds: 3),
                    ));
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/coach_homepage');
                },
                child: const Text('Add'),
              ),
            ],
          ),
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
