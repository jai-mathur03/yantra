import 'package:flutter/material.dart';
import 'package:yantra_blackspace/constants.dart';
import 'package:yantra_blackspace/screens/data_screen.dart';
import 'package:yantra_blackspace/screens/home_content.dart';
import 'package:yantra_blackspace/screens/profile_screen.dart';
import 'package:yantra_blackspace/widgets/line_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeContent(), // Home Tab Content
    DataScreen(), // Data Tab Content
    ProfileScreen(), // Profile Tab Content
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Just update index to switch content
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
