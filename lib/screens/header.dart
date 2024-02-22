import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 110),
          Center(
            child: Text('Login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              // fontFamily: 'NovaSquare',
              fontSize: 40
            ),),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text("Welcome...!",
            style: TextStyle(
              color: Colors.white,
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