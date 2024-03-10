import 'package:flutter/material.dart';

class AthleteNetwork extends StatefulWidget {
  const AthleteNetwork({super.key});

  @override
  State<AthleteNetwork> createState() => _AthleteNetworkState();
}

class _AthleteNetworkState extends State<AthleteNetwork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
      ),
      
    );
  }
}