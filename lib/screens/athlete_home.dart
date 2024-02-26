import 'package:flutter/material.dart';

class AthleteHome extends StatelessWidget {
  const AthleteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Athlete HomePage', style: TextStyle(fontSize: 30),)
          ],
        )
      ),
    );
  }
}