import 'package:flutter/material.dart';
import 'package:servo/screens/employer/employer_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployerMenuScreen extends StatefulWidget {
  const EmployerMenuScreen({Key? key}) : super(key: key);

  @override
  State<EmployerMenuScreen> createState() => _EmployerMenuScreenState();
}

class _EmployerMenuScreenState extends State<EmployerMenuScreen> {
  String? uid;

  bool isSearching = false;

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const EmployerHomeScreen(),
  ];

  void _getSharedPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = _prefs.getString('uid');
    });
  }

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).accentColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              label: 'Bookmark',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'Members',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
