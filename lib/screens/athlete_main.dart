import 'package:flutter/material.dart';
import 'package:sportss_rise/screens/athlete_home.dart';
import 'package:sportss_rise/screens/athlete_network.dart';
import 'package:sportss_rise/screens/athlete_profile.dart';


class AthleteMain extends StatefulWidget {
  const AthleteMain({super.key});

  @override
  State<AthleteMain> createState() => _AthleteMainState();
}

class _AthleteMainState extends State<AthleteMain> {

  int _selectedIndex = 0;
  
  void _onItemTapped( int index) {
    setState(() {
    _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          AthleteHome(),
          AthleteNetwork(),
          AthleteProfile()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Connect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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