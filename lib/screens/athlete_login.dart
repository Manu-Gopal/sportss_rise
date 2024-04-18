import 'package:flutter/material.dart';
import 'header.dart';
import 'athlete_input_wrapper.dart';

class AthleteLogin extends StatelessWidget {
  const AthleteLogin({super.key});

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
                Colors.white54,
                Colors.white
                // Color.fromARGB(255, 3, 144, 163),
                // Color.fromARGB(255, 3, 201, 227),
                // Color.fromARGB(255, 2, 155, 175)
              ])),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 285,
                child: Header(),
              ),
              SizedBox(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
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
