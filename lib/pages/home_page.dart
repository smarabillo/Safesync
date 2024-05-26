import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:safesyncv2/pages/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_page.dart';
import 'location_page.dart';
import 'reports_create.dart';
import 'reports_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions(String username) => <Widget>[
        DashboardPage(username: username),
        MenuPage(),
        const LocationPage(),
        const AccountPage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: const Color(0xFF1375E8),
      ),
      child: Scaffold(
        body: _widgetOptions(username).elementAt(_selectedIndex),

        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
             BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.list_dash),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.location),
              label: 'Locations',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_alt_circle),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF1375E8),
          unselectedItemColor: Colors.black45,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final String username;

  const DashboardPage({Key? key, required this.username}) : super(key: key);

  void _onPlusButtonPressed(BuildContext context) {
    showReportsDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: const Color(0xFF1375E8),
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'Welcome Back, $username',
                    style: const TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(
                  CupertinoIcons.bell_fill,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ReportsHistory(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onPlusButtonPressed(context),
        child: const Icon(Icons.edit_note),
        backgroundColor: const Color(0xFF1375E8),
        foregroundColor: Colors.white,
      ),
    );
  }
}
