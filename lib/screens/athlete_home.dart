import 'package:flutter/material.dart';

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
                            'images/cricket_2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(
                                8.0),
                            child: const Text(
                              'Cricket',
                              style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize: 18.0,
                                fontWeight: FontWeight
                                    .bold,
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                              context, '/athlete_cricket');
                              },
                              child:
                                  Container(),
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
                            'images/football_2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(
                                8.0),
                            child: const Text(
                              'Football',
                              style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize: 18.0,
                                fontWeight: FontWeight
                                    .bold,
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                              context, '/athlete_football');
                              },
                              child:
                                  Container(),
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
                            'images/badminton_4.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(
                                8.0),
                            child: const Text(
                              'Badminton',
                              style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize: 18.0,
                                fontWeight: FontWeight
                                    .bold,
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                              context, '/athlete_badminton');
                              },
                              child:
                                  Container(),
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
                            'images/basketball_5.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(
                                8.0),
                            child: const Text(
                              'Basketball',
                              style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize: 18.0,
                                fontWeight: FontWeight
                                    .bold,
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                              context, '/athlete_basketball');
                              },
                              child:
                                  Container(),
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
                            'images/volley_1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(
                                8.0),
                            child: const Text(
                              'Volleyball',
                              style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize: 18.0,
                                fontWeight: FontWeight
                                    .bold,
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                              context, '/athlete_volleyball');
                              },
                              child:
                                  Container(),
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
                            'images/swim_4.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(
                                8.0),
                            child: const Text(
                              'Swimming',
                              style: TextStyle(
                                color: Colors
                                    .black,
                                fontSize: 18.0,
                                fontWeight: FontWeight
                                    .bold,
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                              context, '/athlete_swimming');
                              },
                              child:
                                  Container(),
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
