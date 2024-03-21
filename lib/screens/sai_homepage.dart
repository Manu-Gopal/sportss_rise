import 'package:flutter/material.dart';
import 'package:sportss_rise/screens/sai_coaches.dart';
import 'package:sportss_rise/screens/sai_news.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaiHomePage extends StatefulWidget {
  const SaiHomePage({super.key});

  @override
  State<SaiHomePage> createState() => _SaiHomePageState();
}

class _SaiHomePageState extends State<SaiHomePage> {

  int _selectedIndex = 0;

  void _onItemTapped( int index) {
    setState(() {
    _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          SaiNews(),
          SaiCoaches()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Coaches',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 25,
        showUnselectedLabels: true,
      )
    );
  }
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  final supabase = Supabase.instance.client;
  dynamic useremail = '';
  dynamic username = '';

  @override
  void initState() {
    super.initState();
    useremail = supabase.auth.currentUser!.email;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            accountEmail: Text(useremail,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            decoration: const BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: AssetImage('images/sai_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              // Navigator.pushNamed(context, '/visitor_bookings');
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const VisitorBookings()));
            },
            leading: const Icon(
              Icons.newspaper_outlined,
              color: Colors.black,
            ),
            title: const Text(
              "Latest News",
              style: TextStyle(
                // fontFamily: 'RobotoSlab',
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}