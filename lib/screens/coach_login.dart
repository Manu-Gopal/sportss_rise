import 'package:flutter/material.dart';
import 'package:sportss_rise/screens/coach_input_wrapper.dart';
import 'header.dart';

class CoachLogin extends StatelessWidget {
  const CoachLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.white70,
                Colors.white
                // Color.fromARGB(255, 3, 144, 163),
                // Color.fromARGB(255, 3, 201, 227),
                // Color.fromARGB(255, 2, 155, 175)
              ])),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 270,
                child: Header(),
              ),
              SizedBox(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: const CoachInputWrapper(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
