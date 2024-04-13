import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:sportss_rise/screens/coach_athlete_profile_view.dart';
import 'package:sportss_rise/screens/coach_manage_news.dart';
import 'package:sportss_rise/screens/coach_profile_page.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class CoachHomePage extends StatefulWidget {
  const CoachHomePage({super.key});

  @override
  State<CoachHomePage> createState() => _CoachHomePageState();
}

class _CoachHomePageState extends State<CoachHomePage> {

  int _selectedIndex = 0;
  
  void _onItemTapped( int index) {
    setState(() {
    _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const CustomDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          CoachAthleteProfileView(),
          CoachManageNews(),
          CoachProfilePage()
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        index: _selectedIndex,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.group),
            label: 'Athletes',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.newspaper_outlined),
            label: 'News',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          _onItemTapped(index);
        },
      )
    );
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