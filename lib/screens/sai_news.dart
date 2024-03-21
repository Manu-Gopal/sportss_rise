import 'package:flutter/material.dart';

class SaiNews extends StatefulWidget {
  const SaiNews({super.key});

  @override
  State<SaiNews> createState() => _SaiNewsState();
}

class _SaiNewsState extends State<SaiNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
    );
  }
}