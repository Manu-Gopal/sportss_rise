import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoachInputWrapper extends StatefulWidget {
  const CoachInputWrapper({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CoachInputWrapperState createState() => _CoachInputWrapperState();
}

class _CoachInputWrapperState extends State<CoachInputWrapper> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey //200
                              ))),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 78, 66, 66),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey //200
                              ))),
                  child: TextFormField(
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
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              final supabase = Supabase.instance.client;
              String email = emailController.text;
              String password = passwordController.text;

              if (email.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Fill the details.'),
                  duration: Duration(seconds: 2),
                ));
                return;
              }
              try {
                await supabase.auth.signInWithPassword(
                    email: email, password: password);
                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(
                    context, '/coach_homepage', (route) => false);
              } catch (e) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invalid Entry.'),
                  duration: Duration(seconds: 3),
                ));
                return;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 11, 72, 103),
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
