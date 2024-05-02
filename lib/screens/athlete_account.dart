import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AthleteAccount extends StatefulWidget {
  const AthleteAccount({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AthleteAccountState createState() => _AthleteAccountState();
}

class _AthleteAccountState extends State<AthleteAccount> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  dynamic imageFile;
  bool image = false;
  dynamic imageUrl;
  dynamic sportDetails;
  dynamic sport;
  dynamic pos;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.white,
                Colors.white70,
                Colors.white
                // Color.fromARGB(255, 3, 144, 163),
                // Color.fromARGB(255, 3, 201, 227),
                // Color.fromARGB(255, 2, 155, 175),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'images/sai_logo.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Athlete',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  height: 800, // Set the desired height for the container
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Set the background color for the container
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          labelText: 'Name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 78, 66, 66),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: dateOfBirthController,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now());
                              dateOfBirthController.text =
                                  DateFormat('yyyy-MM-dd').format(picked!);
                            },
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              hintText: 'yyyy-mm-dd',
                              prefixIcon: const Icon(
                                Icons.calendar_month,
                                color: Color.fromARGB(255, 78, 66, 66),
                              ),
                              // contentPadding: EdgeInsets.all(12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Color.fromARGB(255, 78, 66, 66),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 78, 66, 66),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color.fromARGB(255, 78, 66, 66),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Phone No',
                          labelText: 'Phone No',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 78, 66, 66),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
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
                          child: const Text("Upload Profile Image")),
                      const SizedBox(height: 35.0),
                      ElevatedButton(
                        onPressed: () async {
                          final supabase = Supabase.instance.client;
                          String name = nameController.text;
                          String dob = dateOfBirthController.text;
                          String email = emailController.text;
                          String password = passwordController.text;
                          String phone = phoneController.text;

                          if (name.isEmpty ||
                              dob.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty ||
                              phone.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Please fill all details.'),
                              duration: Duration(seconds: 3),
                            ));
                            return;
                          } else {
                            if (phone.length != 10) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('Phone number should be 10 digits.'),
                                duration: Duration(seconds: 3),
                              ));
                              return;
                            } else {
                              try {
                                final AuthResponse res = await supabase.auth
                                    .signUp(email: email, password: password);

                                if (imageFile != null) {
                                image = true;
                              }

                              final Map<String, dynamic> userDetails = {
                                'user_id': res.user!.id,
                                'name': name,
                                'phone': phone,
                                'dob': dob,
                                'image': image,
                              };

                              final response = await supabase
                                  .from('profile')
                                  .insert(userDetails)
                                  .select();

                              final String profileId = response[0]['id'];

                              if (imageFile != null) {
                                await Supabase.instance.client.storage
                                    .from('images')
                                    .upload(
                                      'item_images/$profileId',
                                      imageFile,
                                      fileOptions: const FileOptions(
                                          cacheControl: '3600', upsert: false),
                                    );
                                  final String publicUrl = Supabase
                                  .instance.client.storage
                                  .from('images')
                                  .getPublicUrl('item_images/$profileId');

                                  await supabase
                                  .from('profile')
                                  .update({'image_url': publicUrl}).match(
                                      {'id': profileId});
                                }

                                // final existingUser = await supabase.auth.(email: email);
                                // if (existingUser != null) {
                                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                //     content: Text('Email address already registered.'),
                                //     duration: Duration(seconds: 3),
                                //   ));
                                //   return;
                                // }
                                // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Account Created Successfully.'),
                                duration: Duration(seconds: 3),
                              ));
                              // ignore: use_build_context_synchronously
                          Navigator.pushNamed(context, '/athlete_login');
                                } on PostgrestException catch (error) {
                                print(error.toString());
                                if (error
                                    .toString()
                                    .contains('already registered')) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Email address already registered.'),
                                    duration: Duration(seconds: 3),
                                  ));
                                  return;
                                } else {
                                  print(error.toString());
                                }
                              } catch (error) {

                                print(error.toString());
                              }
                              
                            }
                          }
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 99, 172, 172),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 65, vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Create Account',
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
              ],
            ),
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
