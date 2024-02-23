import 'package:flutter/material.dart';

class SportsAuthorityHome extends StatelessWidget {
  const SportsAuthorityHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Sports Authority Home', style: TextStyle(fontSize: 30),)
          ],
        )
      ),
    );
  }
}