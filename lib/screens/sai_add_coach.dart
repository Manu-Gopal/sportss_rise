import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SaiAddCoach extends StatefulWidget {
  const SaiAddCoach({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SaiAddCoachState createState() => _SaiAddCoachState();
}

// enum SportsItems { Football, Cricket, Defender, Goalkeeper }

class _SaiAddCoachState extends State<SaiAddCoach> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  dynamic imageFile;
  dynamic imageUrl;
  bool image = false;
  final ImagePicker imagePicker = ImagePicker();

  bool _obscureText = true;

  String dropdownvalue = 'Football';
  var sportItems = [
    'Football',
    'Cricket',
    'Badminton',
    'Basketball',
    'Volleyball',
    'Swimming',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Coach'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Color.fromARGB(255, 3, 144, 163),
            Color.fromARGB(255, 3, 201, 227),
            Color.fromARGB(255, 2, 155, 175)
          ])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  'Add Coach', // Heading text
                  style: TextStyle(
                      fontSize: 30,
                      // fontFamily: 'NovaSquare',
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                      // color: Color.fromARGB(255, 78, 66, 66),
                      ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  height: 650, // Set the desired height for the container
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Set the background color for the container
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            hintText: 'Coach Name',
                            labelText: 'Coach Name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 78, 66, 66),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)))),
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
                                    BorderRadius.all(Radius.circular(20.0)))),
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
                        // inputFormatters: <TextInputFormatter>[
                        //   FilteringTextInputFormatter.digitsOnly
                        // ],
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
                                    BorderRadius.all(Radius.circular(20.0)))),
                      ),
                      Row(
                      children: [
                        const Text(
                          'Choose Sport:',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(width: 15),
                        DropdownButton(
                          // Initial Value
                          value: dropdownvalue,
      
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
      
                          // Array list of items
                          items: sportItems.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ],
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
                      const SizedBox(height: 40.0),
                      ElevatedButton(
                        onPressed: () async {
                          // ... (rest of your code remains unchanged)
                          final supabase = Supabase.instance.client;
                          String name = nameController.text;
                          String email = emailController.text;
                          String password = passwordController.text;
                          String phone = phoneController.text;

                          if (name.isEmpty ||
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

                              final Map<String, dynamic> coachDetails = {
                                'coach_user_id': res.user!.id,
                                'name': name,
                                'phone': phone,
                                'sport':dropdownvalue,
                                'image':image
                              };

                              final response = await supabase
                                  .from('coach_profile')
                                  .insert(coachDetails)
                                  .select();

                              final int profileId = response[0]['id'];

                              if (imageFile != null) {
                                await Supabase.instance.client.storage
                                    .from('images')
                                    .upload(
                                      'coach_images/$profileId',
                                      imageFile,
                                      fileOptions: const FileOptions(
                                          cacheControl: '3600', upsert: false),
                                    );
                                  final String publicUrl = Supabase
                                  .instance.client.storage
                                  .from('images')
                                  .getPublicUrl('coach_images/$profileId');

                                  await supabase
                                  .from('coach_profile')
                                  .update({'image_url': publicUrl}).match(
                                      {'id': profileId});
                                }
                              } on PostgrestException catch (error) {
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Coach Added Successfully.'),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(context, '/sai_homepage');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 99, 172, 172),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 65, vertical: 17),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text(
                          'Add Coach',
                          style: TextStyle(
                            // color: Colors.black,
                            color: Colors.white,
                            fontSize: 23.0,
                            // fontFamily: 'NovaSquare',
                            // fontFamily: 'RobotoSlab',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 125,
                )
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
