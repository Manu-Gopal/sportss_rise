import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
      //   color: Colors.white
      // ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.black38,
              Colors.black
        // Color.fromARGB(255, 3, 144, 163),
        // Color.fromARGB(255, 3, 201, 227),
        // Color.fromARGB(255, 2, 155, 175)
      ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            // 'images/sai_logo_White.png',
            'images/sai_logo.png',
            height: 150,
            width: 150,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SPORTS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40.0, // Set font size
                  fontWeight: FontWeight.bold, // Make bold
                  color: Colors.black, // Set color
                ),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'RISE',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40.0, // Set font size
                  fontWeight: FontWeight.bold, // Make bold
                  color: Colors.black, // Set color
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 280,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sai_homepage');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(const Color.fromARGB(255, 100, 99, 99)),
                          // MaterialStateProperty.all<Color>(const Color.fromARGB(255, 11, 72, 103)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                    child: const Text(
                      'Login as SAI',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'RobotoSlab',
                          //fontFamily: 'NovaSquare',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 280,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/coach_login');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(const Color.fromARGB(255, 100, 99, 99)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                    child: const Text(
                      'Coaches',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'RobotoSlab',
                          //fontFamily: 'NovaSquare',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 280,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/athlete_login');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(const Color.fromARGB(255, 100, 99, 99)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                    child: const Text(
                      'Athlete',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'RobotoSlab',
                          //fontFamily: 'NovaSquare',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
