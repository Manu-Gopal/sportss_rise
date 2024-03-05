import 'package:flutter/material.dart';
// import 'package:sportss_rise/screens/athlete_main.dart';

class AthleteHome extends StatelessWidget {
  const AthleteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Athlete Home'),
        ),
        body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Athlete Home Page',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'images/cricket_2.jpg'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      // Use Stack for positioning
                      children: [
                        // Background image (already defined)
                        Positioned(
                          // Text at top center
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            // Container for styling and centering
                            padding: const EdgeInsets.all(
                                8.0), // Adjust padding if needed
                            child: const Text(
                              'Cricket',
                              style: TextStyle(
                                color: Colors
                                    .black, // Adjust text color for better visibility on image
                                fontSize: 18.0, // Adjust font size as needed
                                fontWeight: FontWeight
                                    .bold, // Add boldness for emphasis (optional)
                              ),
                              textAlign:
                                  TextAlign.center, // Center text horizontally
                            ),
                          ),
                        ),
                        // InkWell on top for click functionality (optional)
                        Positioned.fill(
                          // Fills the entire container
                          child: Material(
                            // Transparent background for InkWell
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Handle cricket tap
                              },
                              child:
                                  Container(), // Empty container to capture taps
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'images/football_2.jpg'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      // Use Stack for positioning
                      children: [
                        // Background image (already defined)
                        Positioned(
                          // Text at top center
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            // Container for styling and centering
                            padding: const EdgeInsets.all(
                                8.0), // Adjust padding if needed
                            child: const Text(
                              'Football',
                              style: TextStyle(
                                color: Colors
                                    .black, // Adjust for better visibility on image
                                fontSize: 18.0, // Adjust font size as needed
                                fontWeight: FontWeight
                                    .bold, // Add boldness for emphasis (optional)
                              ),
                              textAlign:
                                  TextAlign.center, // Center text horizontally
                            ),
                          ),
                        ),
                        // InkWell on top for click functionality
                        Positioned.fill(
                          // Fills the entire container for clicks
                          child: Material(
                            // Transparent background for InkWell
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Handle football tap (implement your desired action)
                                Navigator.pushNamed(
                              context, '/athlete_football');
                              },
                              child:
                                  Container(), // Empty container to capture taps
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'images/badminton_4.jpg'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      // Use Stack for positioning
                      children: [
                        // Background image (already defined)
                        Positioned(
                          // Text at top center
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            // Container for styling and centering
                            padding: const EdgeInsets.all(
                                8.0), // Adjust padding if needed
                            child: const Text(
                              'Badminton',
                              style: TextStyle(
                                color: Colors
                                    .black, // Adjust for better visibility on image
                                fontSize: 18.0, // Adjust font size as needed
                                fontWeight: FontWeight
                                    .bold, // Add boldness for emphasis (optional)
                              ),
                              textAlign:
                                  TextAlign.center, // Center text horizontally
                            ),
                          ),
                        ),
                        // InkWell on top for click functionality
                        Positioned.fill(
                          // Fills the entire container for clicks
                          child: Material(
                            // Transparent background for InkWell
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Handle badminton tap (implement your desired action)
                              },
                              child:
                                  Container(), // Empty container to capture taps
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'images/basketball_5.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      // Use Stack for positioning
                      children: [
                        // Background image (already defined)
                        Positioned(
                          // Text at top center
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            // Container for styling and centering
                            padding: const EdgeInsets.all(
                                8.0), // Adjust padding if needed
                            child: const Text(
                              'Basketball',
                              style: TextStyle(
                                color: Colors
                                    .black, // Adjust text color for better visibility on image
                                fontSize: 18.0, // Adjust font size as needed
                                fontWeight: FontWeight
                                    .bold, // Add boldness for emphasis (optional)
                              ),
                              textAlign:
                                  TextAlign.center, // Center text horizontally
                            ),
                          ),
                        ),
                        // InkWell on top for click functionality
                        Positioned.fill(
                          // Fills the entire container
                          child: Material(
                            // Transparent background for InkWell
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Handle basketball tap
                              },
                              child:
                                  Container(), // Empty container to capture taps
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'images/volley_1.jpg'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      // Use Stack for positioning
                      children: [
                        // Background image (already defined)
                        Positioned(
                          // Text at top center
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            // Container for styling and centering
                            padding: const EdgeInsets.all(
                                8.0), // Adjust padding if needed
                            child: const Text(
                              'Volleyball',
                              style: TextStyle(
                                color: Colors
                                    .black, // Adjust text color for better visibility on image
                                fontSize: 18.0, // Adjust font size as needed
                                fontWeight: FontWeight
                                    .bold, // Add boldness for emphasis (optional)
                              ),
                              textAlign:
                                  TextAlign.center, // Center text horizontally
                            ),
                          ),
                        ),
                        // InkWell on top for click functionality
                        Positioned.fill(
                          // Fills the entire container
                          child: Material(
                            // Transparent background for InkWell
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Handle basketball tap
                              },
                              child:
                                  Container(), // Empty container to capture taps
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'images/swim_4.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      // Use Stack for positioning
                      children: [
                        // Background image (already defined)
                        Positioned(
                          // Text at top center
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            // Container for styling and centering
                            padding: const EdgeInsets.all(
                                8.0), // Adjust padding if needed
                            child: const Text(
                              'Swimming',
                              style: TextStyle(
                                color: Colors
                                    .black, // Adjust text color for better visibility on image
                                fontSize: 18.0, // Adjust font size as needed
                                fontWeight: FontWeight
                                    .bold, // Add boldness for emphasis (optional)
                              ),
                              textAlign:
                                  TextAlign.center, // Center text horizontally
                            ),
                          ),
                        ),
                        // InkWell on top for click functionality
                        Positioned.fill(
                          // Fills the entire container
                          child: Material(
                            // Transparent background for InkWell
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Handle basketball tap
                              },
                              child:
                                  Container(), // Empty container to capture taps
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
