import 'package:flutter/material.dart';
import 'header.dart';
import 'athlete_input_wrapper.dart';

class CoachLogin extends StatelessWidget {
  const CoachLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 3, 144, 163),
                Color.fromARGB(255, 3, 201, 227),
                Color.fromARGB(255, 2, 155, 175)
              ]
            )
          ),
          child: Column(
            children: <Widget> [
              const SizedBox(
                height: 260,
                child: Header(),
              ),
              SizedBox(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)
                    )
                  ),

                  child: const AthleteInputWrapper(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}