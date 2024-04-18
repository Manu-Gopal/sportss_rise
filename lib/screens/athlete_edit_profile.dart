import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AthleteEditProfile extends StatefulWidget {
  const AthleteEditProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AthleteEditProfileState createState() => _AthleteEditProfileState();
}

class _AthleteEditProfileState extends State<AthleteEditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  dynamic imageFile;
  bool image = false;

  // bool _obscureText = true; // State variable to control password visibility

  final supabase = Supabase.instance.client;

  dynamic userId = Supabase.instance.client.auth.currentUser!.id;

  dynamic userData;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {  
      getData();
      // setState(() {});
    });
  }

  Future getData() async {
    userData = await Supabase.instance.client
          .from('profile')
          .select()
          .eq('user_id', userId);
    
  nameController.text = userData[0]['name'];
  phoneController.text = userData[0]['phone'];
  dateOfBirthController.text = userData[0]['dob'];
  image = userData[0]['image'];

  setState(() {});
  }

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
                    color: Colors.black,
                    fontFamily: 'Poppins'
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  height: 800, // Set the desired height for the container
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color for the container
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
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                                dateOfBirthController.text=DateFormat('yyyy-MM-dd').format(picked!);
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
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                          
                          child: const Text("Update Profile Image", style: TextStyle(fontFamily: 'RobotoSlab'),)),

                      const SizedBox(height: 35.0),
                      ElevatedButton(
                        onPressed: () async {
                          final supabase = Supabase.instance.client;
                          String name = nameController.text;
                          String dob = dateOfBirthController.text;
                          String phone = phoneController.text;

                          if (name.isEmpty ||
                              dob.isEmpty ||
                              phone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Please fill all details.'),
                              duration: Duration(seconds: 3),
                            ));
                            return;
                          } else {
                            if (phone.length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Phone number should be 10 digits.'),
                                duration: Duration(seconds: 3),
                              ));
                              return;
                            } else {
                              // final AuthResponse res = await supabase.auth.signUp(email: email, password: password);
                              if (imageFile != null) {
                              image = true;
                            } else {
                              image = image;
                            }
                            // if (imageFile == null){
                            //   image = image;
                            // }

                              final Map<String, dynamic> userDetails = {
                                'user_id': userId,
                                'name': name,
                                'phone': phone,
                                'dob': dob,
                                'image': image
                              };

                              final response = await supabase.from('profile').update(userDetails).eq('user_id', userId).select();

                              if (imageFile != null) {
                              await Supabase.instance.client.storage
                                  .from('images')
                                  .upload(
                                    'item_images/${response[0]['id']}',
                                    imageFile,
                                    fileOptions: const FileOptions(
                                        cacheControl: '3600', upsert: true),
                                  );
                            }

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Details Updated Successfully.'),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(context, '/athlete_profile').then((value) => setState(() => {}));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 99, 172, 172),
                          padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Edit Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23.0,
                            fontFamily: 'RobotoSlab'
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
