import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        Color.fromARGB(255, 3, 144, 163),
        Color.fromARGB(255, 3, 201, 227),
        Color.fromARGB(255, 2, 155, 175)
      ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
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
                      // Navigator.pushNamed(context, '/sports_authority_login');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                    child: const Text(
                      'Sports Authority',
                      style: TextStyle(
                          fontSize: 20,
                          //fontFamily: 'NovaSquare',
                          color: Colors.black,
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
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                    child: const Text(
                      'Athlete',
                      style: TextStyle(
                          fontSize: 20,
                          //fontFamily: 'NovaSquare',
                          color: Colors.black,
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
