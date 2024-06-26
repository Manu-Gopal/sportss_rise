import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AthleteHome extends StatefulWidget {
  const AthleteHome({Key? key}) : super(key: key);

  @override
  _AthleteHomeState createState() => _AthleteHomeState();
}

class _AthleteHomeState extends State<AthleteHome> {
  final supabase = Supabase.instance.client;
  dynamic userId = Supabase.instance.client.auth.currentUser!.id;
  bool isLoading = false;
  dynamic sport;
  dynamic athleteSport;


  @override
  void initState() {
    super.initState();
    getSport();
  }

  Future getSport() async {
    setState(() {
      isLoading = true;
    });
    sport = await supabase.from('profile').select('sport').eq('user_id', userId);
    athleteSport = sport[0]['sport'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 72, 103),
          title: const Text('SportsRise', style: TextStyle(fontFamily: 'Poppins'),),
        ),
        // drawer: const CustomDrawer(),
        body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Choose Your Sport',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'RobotoSlab'),
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
                            'images/cricket_2BW.jpg'),
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
                                fontFamily: 'RobotoSlab',
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
                              onTap: athleteSport == null ? () {
                                Navigator.pushNamed(
                              context, '/athlete_cricket');
                              } : null,
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
                            'images/football_2BW.jpg'),
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
                                fontFamily: 'RobotoSlab'
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
                              onTap: athleteSport == null ? () {
                                Navigator.pushNamed(
                              context, '/athlete_football');
                              } : null,
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
                                fontFamily: 'RobotoSlab'
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
                              onTap: athleteSport == null ? () {
                                Navigator.pushNamed(
                              context, '/athlete_badminton');
                              } : null,
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
                                fontFamily: 'RobotoSlab'
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
                              onTap: athleteSport == null ? () {
                                Navigator.pushNamed(
                              context, '/athlete_basketball');
                              } : null,
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
                                fontFamily: 'RobotoSlab'
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
                              onTap: athleteSport == null ? () {
                                Navigator.pushNamed(
                              context, '/athlete_volleyball');
                              } : null,
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
                                fontFamily: 'RobotoSlab'
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
                              onTap: athleteSport == null ? () {
                                Navigator.pushNamed(
                              context, '/athlete_swimming');
                              } : null,
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

// class CustomDrawer extends StatefulWidget {
//   const CustomDrawer({super.key});

//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }

// class _CustomDrawerState extends State<CustomDrawer> {

//   final supabase = Supabase.instance.client;
//   dynamic useremail = '';
//   dynamic username = '';

//   @override
//   void initState() {
//     super.initState();
//     useremail = supabase.auth.currentUser!.email;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: const Text(
//               '',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//             accountEmail: Text(useremail,
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             decoration: const BoxDecoration(
//               color: Colors.green,
//               image: DecorationImage(
//                 image: AssetImage('images/sai_logo.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           ListTile(
//             onTap: () {
//               // Navigator.pushNamed(context, '/visitor_bookings');
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => const VisitorBookings()));
//             },
//             leading: const Icon(
//               Icons.newspaper_outlined,
//               color: Colors.black,
//             ),
//             title: const Text(
//               "Latest News",
//               style: TextStyle(
//                 // fontFamily: 'RobotoSlab',
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
