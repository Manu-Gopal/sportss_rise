import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center, // Positions the image to the right
            child: Image.asset(
              'images/sai_logo.png',
              height: 100,
              width: 100,
            ),
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text('Login',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoSlab',
              // fontFamily: 'NovaSquare',
              fontSize: 40
            ),),
          ),
          const SizedBox(height: 10,),
          const Center(
            child: Text("Welcome...!",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'RobotoSlab',
              // fontFamily: 'NovaSquare',
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),),
          )
        ],
      ),
    );
  }
}